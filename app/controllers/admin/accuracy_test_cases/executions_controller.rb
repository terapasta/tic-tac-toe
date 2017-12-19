class Admin::AccuracyTestCases::ExecutionsController < ApplicationController
  def create
    Delayed::Job.enqueue ExecuteAllBotTestsJob.new

    redirect_to root_path, notice: 'Succeeded all bot accuracy tests'
  end

  class ExecuteAllBotTestsJob
    include ReplyTestable
    def perform
      helper = SlackBotHelper.new
      attachments = helper.generate_attachments(all_bot_accuracy_test!)
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.post text: '現在の各ボットの正答率ですよ', channel: '#dev', attachments: attachments
    end
  end
end
