class QuestionAnswer::CsvImporter
  ModeEncForUTF8 = 'r'
  ModeEncForSJIS = 'rb:Shift_JIS:UTF-8'

  class EmptyQuestionError < StandardError; end
  class EmptyAnswerError < StandardError; end

  attr_reader :succeeded, :current_row, :error_message

  def initialize(file, bot, options = {})
    @file = file
    @bot = bot
    @options = { is_utf8: false }.merge(options)
    @mode_enc = options[:is_utf8] ? ModeEncForUTF8 : ModeEncForSJIS
    @current_answer = nil
    @current_row = nil
    @succeeded = false
    @error_message = nil
  end

  def import
    csv_data = parse
    ActiveRecord::Base.transaction do
      csv_data.each do |import_param|
        question_answer = @bot.question_answers.where(id: import_param[:question_answer_attributes][:id])
          .first_or_initialize(import_param[:question_answer_attributes])
        question_answer.tap do |qa|
          qa.answer = import_param[:answer_body]
          qa.save!
          if import_param[:topic_tag_names].present?
            topic_tag_names = import_param[:topic_tag_names]
            target_topic_tags = @bot.topic_tags.where(name: topic_tag_names)
            new_topic_tags = target_topic_tags - question_answer.topic_tags
            qa.topic_taggings.create(new_topic_tags.map{ |t| { topic_tag_id: t.id } })
          end
        end

        create_underlayer_records(question_answer, import_param[:decision_branches_attributes])
      end
    end
    @succeeded = true
  rescue EmptyQuestionError => e
    @error_message = '質問を入力してください'
  rescue EmptyAnswerError => e
    @error_message = '回答を入力してください'
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
  end

  def create_underlayer_records(question_answer, decision_branches_attrs)
    decision_branches_attrs.each do |db_attrs|
      decision_branch = question_answer.decision_branches.find_or_initialize_by(body: db_attrs[:body], bot_id: @bot.id)
      decision_branch.tap do |x|
        x.answer_id = 0 # TODO: 必須なので0を代入しているがあとで消す
        x.answer = db_attrs[:next_answer_body]
        x.question_answer = question_answer
        x.save!
      end
    end
  end

  def parse
    f = open(@file.path, @mode_enc, undef: :replace)
    raw_data = f.read.encode("UTF-16BE", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8")
    CSV.new(raw_data).each_with_index.inject({}) { |out, (row, index)|
      @current_row = index + 1
      data = detect_or_initialize_by_row(row)
      decision_branches = out[data[:key]].try(:fetch, :decision_branches_attributes) || []
      decision_branches.push(data[:decision_branch]) if data[:decision_branch].present?
      out[data[:key]] = {
        question_answer_attributes: {
          id: data[:id],
          bot_id: @bot.id,
          question: data[:question],
        },
        answer_body: data[:answer],
        decision_branches_attributes: decision_branches,
        topic_tag_names: data[:topic_tag_names],
      }
      out
    }.values
  end

  def detect_or_initialize_by_row(row)
    id = sjis_safe(row[0]).to_i
    topic_tag_names = sjis_safe(row[1])&.gsub('／', '/')&.split("/")&.map(&:strip) || []
    q = sjis_safe(row[2])
    a = sjis_safe(row[3])
    decision_branch = sjis_safe(row[4])
    next_answer = sjis_safe(row[5])
    bot_had = @bot.question_answers.detect {|qa| qa.id == id}.present?
    fail EmptyQuestionError.new if q.blank?
    fail EmptyAnswerError.new if a.blank?

    {
      key: bot_had ? id : "#{q}-#{a}",
      id: bot_had ? id : nil,
      topic_tag_names: topic_tag_names,
      question: q,
      answer: a,
      decision_branch: decision_branch.present? ? { body: decision_branch, next_answer_body: next_answer } : nil,
    }
  end

  private
    def sjis_safe(str)
      SjisSafeConverter.sjis_safe(str)
    end
end
