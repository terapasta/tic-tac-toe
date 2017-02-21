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
        q = sjis_safe(row[0])
        a = sjis_safe(row[1])

        @current_answer = @bot.answers.find_or_create_by!(body: a)

        question_answer = @bot.question_answers.find_or_initialize_by(question: q).tap do |qa|
          qa.answer = @current_answer
          qa.save!
        end

        create_underlayer_records(row)
      end
    end
    @succeeded = true
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
  end

  def create_underlayer_records(row)
    return if row.compact.count <= 2
    row[2..-1].compact.each_slice(2) do |decision_branch_body, answer_body|
      d = sjis_safe(decision_branch_body)
      a = sjis_safe(answer_body)

      decision_branch = @current_answer.decision_branches.find_or_initialize_by(body: d, bot_id: @bot.id)

      if a.present?
        @current_answer = @bot.answers.find_or_initialize_by(body: a, bot_id: @bot.id)
        decision_branch.next_answer = @current_answer
      end

      decision_branch.save!
    end
  end

  private
    def sjis_safe(str)
      SjisSafeConverter.sjis_safe(str)
    end
end
