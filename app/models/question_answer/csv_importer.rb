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
    @encoding = options[:is_utf8] ? Encoding::UTF_8 : Encoding::Shift_JIS
    @current_answer = nil
    @current_row = nil
    @succeeded = false
    @error_message = nil
  end

  def import
    csv_data = parse
    ActiveRecord::Base.transaction do
      csv_data.each do |import_param|
        topic_tag_names = import_param.delete(:topic_tag_names)

        # Q&Aのidでレコードが見つかったら更新
        # それ以外は作成する
        question_answer = begin
          if import_param[:id].present? &&
            (qa = @bot.question_answers.find_by(id: import_param[:id]))
            qa.update!(import_param)
            qa
          else
            @bot.question_answers.create!(import_param)
          end
        end

        if topic_tag_names.present?
          topic_tag_names.each do |tag_name|
            @bot.topic_tags.find_or_create_by!(name: tag_name)
          end
          target_topic_tags = @bot.topic_tags.where(name: topic_tag_names)
          new_topic_tags = target_topic_tags - question_answer.topic_tags
          data = new_topic_tags.map{ |t| { topic_tag_id: t.id } }
          question_answer.topic_taggings.create!(data)
        end
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

  def parse
    raw_data = FileReader.new(file_path: @file.path, encoding: @encoding).read
    CSV.new(raw_data).drop(1).each_with_index.inject({}) { |out, (row, index)|
      @current_row = index + 2 # 元データの行数を表示するため、indexが0始まりの分と、ヘッダ分を加算する
      data = detect_or_initialize_by_row(row)

      topic_tag_names = Array(out[data[:key]].try(:dig, :topic_tag_names))
      topic_tag_names += Array(data[:topic_tag_names])

      out[data[:key]] = {
        id: data[:id],
        question: data[:question],
        answer: data[:answer],
        topic_tag_names: topic_tag_names,
      }
      out
    }.values
  end

  ##
  # 行からデータを抽出する
  def detect_or_initialize_by_row(row)
    id = sjis_safe(row[0]).to_i
    topic_tag_names = sjis_safe(row[1])&.gsub('／', '/')&.split("/")&.map(&:strip) || []
    q = sjis_safe(row[2])
    a = sjis_safe(row[3])

    bot_had = @bot.question_answers.detect{ |qa| qa.id == id }.present?
    fail EmptyQuestionError.new if q.blank?
    fail EmptyAnswerError.new if a.blank?

    {
      key: bot_had ? id : "#{q}-#{a}",
      id: bot_had ? id : nil,
      topic_tag_names: topic_tag_names,
      question: q,
      answer: a,
    }
  end

  private
    def sjis_safe(str)
      SjisSafeConverter.sjis_safe(str)
    end
end
