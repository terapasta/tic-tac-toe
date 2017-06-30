class Admin::Bots::AccuracyTestCases::ExecutionsController < Admin::Bots::BaseController
  include Replyable

  def create
    @accuracy_test_cases = @bot.accuracy_test_cases
    @results = collect_results!
    @success_count = @accuracy_test_cases.select{ |a|
      a.success_result?(@results[a.id])
    }.count
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
end
