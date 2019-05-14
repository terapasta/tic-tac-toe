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
    start_time = date.beginning_of_day
    @created_at = end_time = date.end_of_day

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

  def get_half_year_data
    @half_year_data ||= get_between(
      start_time: HalfYearDays.days.ago.beginning_of_day,
      end_time: Time.current.end_of_day
    )
  end

  def half_year_data
    get_half_year_data.inject([['x'], ['Q&A累計登録件数'], ['Q&A更新回数']]) { |acc, it|
      acc[0].push(it.created_at.beginning_of_day.strftime('%Y-%m-%d'))
      acc[1].push(it.data['question_answers_count'])
      acc[2].push(it.data['update_qa_count'])
      acc
    }
  end
end