class GuestMessagesSummarizer < ApplicationSummarizer
  # 月〜日を1週間とする
  # created_atに週の終わり時刻(日曜の23:59:59)を記録する
  def initialize(bot)
    @bot = bot
    @guest_messages_count = 0
    @created_at = nil
  end

  def summarize(date: nil)
    date = date.nil? ? Time.current : date
    start_time = date.beginning_of_day
    @created_at = end_time = date.end_of_day
    @guest_messages_count = guest_messages_between(start_time: start_time, end_time: end_time).count
  end

  def as_json
    {
      guest_messages_count: @guest_messages_count
    }
  end

  def data_between(start_time, end_time)
    get_between(start_time: start_time, end_time: end_time)
      .inject([['x'], ['チャット質問数']]) { |acc, it|
        acc[0].push(it.created_at.beginning_of_day.strftime('%Y-%m-%d'))
        acc[1].push(it.data['guest_messages_count'])
        acc
      }
  end

  def guest_messages_between(start_time:, end_time:)
    @bot.messages.guest
      .where(created_at: (start_time..end_time))
      .joins(:chat)
        .where(chats: { is_normal: false })
        .where(chats: { is_staff: false })
  end
end