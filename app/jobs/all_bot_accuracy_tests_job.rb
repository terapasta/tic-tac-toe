class AllBotAccuracyTestsJob < ApplicationJob
  include ReplyTestable
  queue_as :default

  def perform
    helper = SlackBotHelper.new
    attachments = helper.generate_attachments(all_bot_accuracy_test!)
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.post text: '現在の各ボットの正答率ですよ', channel: '#dev', attachments: attachments
  end
end
