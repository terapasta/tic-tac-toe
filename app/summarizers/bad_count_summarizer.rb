class BadCountSummarizer
  def initialize(bot_id)
    @bot = Bot.find(bot_id)
    @all_count = 0
    @bad_count = 0
    @bad_rate = 0.0
  end

  def summarize
    data = @bot.messages.includes(:rating).order(created_at: :desc).limit(5000).pluck(:id, 'ratings.level')
    @all_count = data.count
    @bad_count = data.select{ |it| it[1] == 2 }.count
    @bad_rate = @bad_count.to_f / @all_count.to_f
    self
  end

  def as_json
    {
      all_count: @all_count,
      bad_count: @bad_count,
      bad_rate: @bad_rate
    }
  end
end
