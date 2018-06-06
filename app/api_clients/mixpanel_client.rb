class MixpanelClient
  def initialize
    @client = Mixpanel::Client.new(
      api_secret: ENV['MIXPANEL_API_SECRET'],
      timeout: 240
    )
  end

  def update_qa_count_at_between(start_time:, end_time:, bot_id:)
    @client.request(
      'events/properties',
      event: 'update q&a',
      name: 'bot_id',
      values: [bot_id],
      from_date: start_time.strftime('%Y-%m-%d'),
      to_date: end_time.strftime('%Y-%m-%d'),
      type: 'general',
      unit: 'week',
    ).dig('data', 'values')
  end
end