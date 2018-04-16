class BadCountSummarizer < ApplicationSummarizer
  def initialize(bot)
    @bot = bot
    @all_count = 0
    @bad_count = 0
    @bad_rate = 0.0
    @date = nil
  end

  def summarize(date: nil)
    guest_chat_ids = @bot.chats.select(:id).where(is_staff: false, is_normal: false)
    data = @bot.messages
      .bot
      .includes(:rating)
      .where(chat_id: guest_chat_ids)
      .order(created_at: :desc)
      .limit(5000)
    if date.present?
      @date = date
      data = data.where(created_at: (5.years.ago..date))
    end
    data = data.pluck('ratings.level')
    @all_count = data.count
    @bad_count = data.select{ |it| it == Rating.levels[:bad] }.count
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

  def get_thirty_days_data
    @thirty_days_data ||= get_between(
      start_time: 30.days.ago.beginning_of_day,
      end_time: Time.current.end_of_day
    )
  end

  def thirty_days_chart_data
    get_thirty_days_data.inject([['x'], ['Bad評価率']]) { |acc, it|
      acc[0].push(it.created_at.strftime('%Y-%m-%d'))
      acc[1].push((it.data['bad_rate'] * 100).round(2))
      acc
    }
  end
end
