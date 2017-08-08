class Admin::Bots::AccuracyTestCases::ExecutionsController < Admin::Bots::BaseController
  include Replyable

  def create
    @accuracy_test_cases = @bot.accuracy_test_cases
    @results = collect_results!
    @success_count = @accuracy_test_cases.select{ |a|
      a.success_result?(@results[a.id])
    }.count
    @success_count_text = "#{@success_count} 成功 / #{@accuracy_test_cases.count} total,"
    @success_percentage_text = "成功率 #{(@success_count.to_f / @accuracy_test_cases.count.to_f * 100).to_i}%"
    notify_to_slack
    render 'admin/bots/accuracy_test_cases/index'
  end

  private
    def collect_results!
      results = {}
      ActiveRecord::Base.transaction do
        @chat = @bot.chats.create(guest_key: SecureRandom.hex(64))
        @accuracy_test_cases.each do |accuracy_test_case|
          message = @chat.messages.create!(
            body: accuracy_test_case.question_text,
            speaker: 'guest',
          )
          bot_messages = receive_and_reply!(@chat, message)
          results[accuracy_test_case.id] = bot_messages
        end
        raise ActiveRecord::Rollback
      end
      results
    end

    def notify_to_slack
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'], channel: "#accuracy_tests"
      notifier.ping(<<-EOS
<!here>
「#{@bot.name}」 の精度テスト結果
    #{@success_count_text}   #{@success_percentage_text}
EOS
      )
    end
end
