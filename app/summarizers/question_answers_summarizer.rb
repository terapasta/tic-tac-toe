class QuestionAnswersSummarizer < ApplicationSummarizer
  # 月〜日を1週間とする
  # created_atに週の終わり時刻(日曜の23:59:59)を記録する
  def initialize(bot)
    @bot = bot
    @question_answers_count = 0
    @update_qa_count = 0
    @created_at = nil
  end

  def summarize(date: nil)
    date = date.nil? ? Time.current : date
    start_time = date.beginning_of_week(StartingDay)
    @created_at = end_time = date.end_of_week(StartingDay)

    mixpanel = MixpanelClient.new
    @update_qa_count = mixpanel.update_qa_count_at_between(
      start_time: start_time,
      end_time: end_time,
      bot_id: @bot.id
    )
    @question_answers_count = @bot.question_answers.count
  end

  def as_json
    {
      question_answers_count: @question_answers_count,
      update_qa_count: @update_qa_count
    }
  end
end