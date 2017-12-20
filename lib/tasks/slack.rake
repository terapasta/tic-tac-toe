namespace :slack do
  task notify_accuracy: :environment do
    include ReplyTestable

    helper = SlackBotHelper.new
    attachments = helper.generate_attachments(all_bot_accuracy_test!)
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.post text: '定期投稿です。 各ボットの正答率', channel: '#dev', attachments: attachments
  end

  def session
    { states: {} }
  end
end
