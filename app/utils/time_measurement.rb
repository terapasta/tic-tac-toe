class TimeMeasurement
  def self.slack_notifier
    @@slack_notifier ||= Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
  end

  def self.measure(name:, bot:, &block)
    start_time = Time.current
    result = block.call
    end_time = Time.current
    duration = end_time - start_time
    if duration > 1.0 && !Rails.env.development?
      slack_notifier.post \
        text: "1秒以上かかる処理が発生しました [#{name}] `bot_id: #{bot.id}` `duration: #{duration}`",
        channel: '#dev'
    end
    result
  end
end