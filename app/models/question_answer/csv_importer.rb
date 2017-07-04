class QuestionAnswer::CsvImporter
  ModeEncForUTF8 = 'r'
  ModeEncForSJIS = 'rb:Shift_JIS:UTF-8'

  attr_reader :succeeded, :current_row

  def initialize(file, bot, options = {})
    @file = file
    @bot = bot
    @options = { is_utf8: false }.merge(options)
    @mode_enc = options[:is_utf8] ? ModeEncForUTF8 : ModeEncForSJIS
    @current_row = nil
    @current_answer = nil
    @succeeded = false
  end

  def import
    f = open(@file.path, @mode_enc, undef: :replace)
    ActiveRecord::Base.transaction do
      CSV.new(f).each_with_index do |row, index|
        @current_row = index + 1
        id = sjis_safe(row[0])
        q = sjis_safe(row[1])
        a = sjis_safe(row[2])
        fail ActiveRecord::RecordInvalid.new(QuestionAnswer.new) if q.blank? || q.blank?

        # 他のbotのquestion_answerに既にidが登録されている場合、buildする
        test_question_answer = QuestionAnswer.find_by(id: id)
        if test_question_answer.present? and test_question_answer.bot_id != @bot.id
          question_answer = @bot.question_answers.build
        end
        question_answer ||= @bot.question_answers.find_or_initialize_by(id: id)
        question_answer.tap do |qa|
          qa.question = q
          qa.answer ||= qa.build_answer(bot_id: @bot.id)
          qa.answer.body = a
          qa.save!
        end

        create_underlayer_records(row, question_answer.answer)
      end
    end
    @succeeded = true
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
  end

  def create_underlayer_records(row, answer)
    return if row.compact.count <= 3
    row[3..-1].compact.each_slice(2) do |decision_branch_body, answer_body|
      d = sjis_safe(decision_branch_body)
      a = sjis_safe(answer_body)

      decision_branch = answer.decision_branches.find_or_initialize_by(body: d, bot_id: @bot.id)

      if a.present?
        decision_branch.next_answer ||= decision_branch.build_next_answer(bot_id: @bot.id)
        decision_branch.next_answer.body = a
      end

      decision_branch.save!
    end
  end

  private
    def sjis_safe(str)
      SjisSafeConverter.sjis_safe(str)
    end
end
