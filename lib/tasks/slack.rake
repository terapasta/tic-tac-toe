namespace :slack do

  task notify_rollback_succeeded: :environment do
    helper = SlackBotHelper.new
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.post text: "[#{Rails.env.upcase}] ロールバックに成功しました。\nデプロイ先のアプリケーションルートにロールバック用のバックアップファイルが作成されているため、不要な場合は手動で削除してください。", channel: '#dev'
  end

  def session
    { states: {} }
  end
end
