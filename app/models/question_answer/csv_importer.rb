class QuestionAnswer::CsvImporter
  ModeEncForUTF8 = 'r'
  ModeEncForSJIS = 'rb:Shift_JIS:UTF-8'

  class EmptyQuestionError < StandardError; end
  class EmptyAnswerError < StandardError; end
  class InvalidUTF8Error < StandardError; end
  class InvalidSJISError < StandardError; end
  class DuplicateQuestionError < StandardError; end
  class DuplicateSubQuestionError < StandardError; end
  class ExistQuestionError < StandardError; end

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
      csv_data.reverse.each.with_index(1) do |import_param, i|
        topic_tag_names = import_param.delete(:topic_tag_names)
        duplicate_question = @bot.question_answers.find_by(question: import_param[:question])
        duplicate_sub_question = @bot.sub_questions.find_by(question: import_param[:question])
        @current_row = i + 1  # 元データの行数を表示するため、ヘッダ分を加算する

        # 重複するsub_questionが存在する場合処理を行わない
        fail DuplicateSubQuestionError.new if duplicate_sub_question

        # 重複するQ&Aが存在し
        # 該当するidがCSVデータ内に存在しない場合更新・作成を行わない
        #
        # Q&Aのidでレコードが見つかったら
        # 他のレコードに重複Q&Aが存在する場合
        # バリデーションをスキップして更新（ユニーク回避）
        # 重複Q&Aが存在しない場合は普通に更新
        #
        # Q&Aのidでレコードが見つからなければ作成
        #
        # NOTE:
        # https://www.pivotaltracker.com/story/show/164296332
        # questionにユニーク制約を設定したため、インポートにも処理を追加
        # 既に登録されているが、CSV内にで該当idの質問が存在する場合
        # その質問は更新されてユニークとなるはずなので、バリデーションをスキップして更新する

        if duplicate_question.present? && csv_data.none?{ |data| data[:id] == duplicate_question.id }
          fail ExistQuestionError.new
        end

        qa = @bot.question_answers.find_by(id: import_param[:id])
        if qa.present?
          if duplicate_question.present?
            qa.assign_attributes(import_param)
            qa.save!(validate: false)
          else
            qa.update!(import_param)
          end
          question_answer = qa
        else
          question_answer = @bot.question_answers.create!(import_param)
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
  rescue ExistQuestionError => e
    @error_message = '質問は既に存在します'
  rescue DuplicateSubQuestionError => e
    @error_message = '重複するサブ質問が存在します'
  rescue DuplicateQuestionError => e
    @error_message = 'データ内で重複している質問が存在します'
  rescue ArgumentError => e
    if e.message.include?('UTF-8')
      raise InvalidUTF8Error.new
    elsif e.message.include?('Shift_JIS')
      raise InvalidSJISError.new
    else
      debug_log(e)
    end
  rescue => e
    debug_log(e)
  end

  def parse
    base_updated_at = Time.current
    raw_data = FileReader.new(file_path: @file.path, encoding: @encoding).read
    CSV.new(raw_data).drop(1).map.with_index(1) { |row, index|
      @current_row = index + 1 # 元データの行数を表示するため、ヘッダ分を加算する
      data = detect_or_initialize_by_row(row)
      fail DuplicateQuestionError if raw_data.split(",").count(data[:question]) > 1 # CSV内に重複QAがある場合エラー
      next if data.nil?

      {
        id: data[:id],
        question: data[:question],
        answer: data[:answer],
        topic_tag_names: Array(data[:topic_tag_names]),
      }
    }.compact.reverse.map.with_index{ |param, index|
      param[:created_at] = base_updated_at + index
      param
    }
  end

  ##
  # 行からデータを抽出する
  def detect_or_initialize_by_row(row)
    return nil if row.nil? || row.compact.count.zero?
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

    def debug_log(e)
      Rails.logger.debug(e)
      Rails.logger.debug(e.backtrace.join("\n"))
    end
end
