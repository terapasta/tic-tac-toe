namespace :slack do
  task notify_accuracy: :environment do
    include ReplyTestable

    helper = SlackBotHelper.new
    attachments = helper.generate_attachments(all_bot_accuracy_test!)
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.post text: '定期投稿です。 各ボットの正答率', channel: '#dev', attachments: attachments
  end

  task notify_rollback_succeeded: :environment do
    helper = SlackBotHelper.new
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.post text: "[#{Rails.env.upcase}] ロールバックに成功しました。\nデプロイ先のアプリケーションルートにロールバック用のバックアップファイルが作成されているため、不要な場合は手動で削除してください。", channel: '#dev'
  end

  def session
    { states: {} }
  end
end
