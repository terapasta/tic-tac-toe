class QuestionAnswer::CsvImporter
  ModeEncForUTF8 = 'r'
  ModeEncForSJIS = 'rb:Shift_JIS:UTF-8'

  attr_reader :succeeded, :current_row

  def initialize(file, bot, options = {})
    @file = file
    @bot = bot
    @options = { is_utf8: false }.merge(options)
    @mode_enc = options[:is_utf8] ? ModeEncForUTF8 : ModeEncForSJIS
    @current_answer = nil
    @succeeded = false
  end

  def import
    csv_data = parse
    ActiveRecord::Base.transaction do
      csv_data.each do |import_param|
        question_answer = @bot.question_answers.where(id: import_param[:question_answer_attributes][:id])
          .first_or_initialize(import_param[:question_answer_attributes])
        fail ActiveRecord::RecordInvalid.new(QuestionAnswer.new) unless question_answer.valid?
        question_answer.tap do |qa|
          qa.answer ||= qa.build_answer(bot_id: @bot.id)
          qa.answer.body = import_param[:answer_body]
          qa.save!
        end

        create_underlayer_records(question_answer.answer, import_param[:decision_branches_attributes])
      end
    end
    @succeeded = true
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
  end

  def create_underlayer_records(answer, decision_branches_attrs)
    decision_branches_attrs.each do |db_attrs|
      decision_branch = answer.decision_branches.find_or_initialize_by(body: db_attrs[:body], bot_id: @bot.id)
      if db_attrs[:next_answer_body].present?
        decision_branch.next_answer ||= decision_branch.build_next_answer(bot_id: @bot.id)
        decision_branch.next_answer.body = db_attrs[:next_answer_body]
        decision_branch.next_answer.save!
      end
      decision_branch.save!
    end
  end

  def parse
    f = open(@file.path, @mode_enc, undef: :replace)
    CSV.new(f).inject({}) { |out, row|
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
      }
      out
    }.values
  end

  def detect_or_initialize_by_row(row)
    id = sjis_safe(row[0]).to_i
    q = sjis_safe(row[1])
    a = sjis_safe(row[2])
    decision_branch = sjis_safe(row[3])
    next_answer = sjis_safe(row[4])
    bot_had = @bot.question_answers.detect {|qa| qa.id == id}.present?

    {
      key: bot_had ? id : "#{q}-#{a}",
      id: bot_had ? id : nil,
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
