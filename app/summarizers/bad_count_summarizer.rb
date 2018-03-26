class BadCountSummarizer < ApplicationSummarizer
  def initialize(bot)
    @bot = bot
    @all_count = 0
    @bad_count = 0
    @bad_rate = 0.0
  end

  def summarize
    data = @bot.messages.includes(:rating).order(created_at: :desc).limit(5000).pluck(:id, 'ratings.level')
    @all_count = data.count
    @bad_count = data.select{ |it| it[1] == 2 }.count
    if @all_count.zero? || @bad_count.zero?
      @bad_rate = 0
    else
      @bad_rate = @bad_count.to_f / @all_count.to_f
    end
  end

  def as_json
    {
      all_count: @all_count,
      bad_count: @bad_count,
      bad_rate: @bad_rate
    }
  end

  def seven_days_chart_data
    get_between(
      start_time: 7.days.ago.beginning_of_day,
      end_time: Time.current.end_of_day
    ).inject([['x'], ['Bad評価率']]) { |acc, it|
      acc[0].push(it.created_at.strftime('%Y-%m-%d'))
      acc[1].push((it.data['bad_rate'] * 100).round(2))
      acc
    }
  end
end
