class Admin::Bots::AccuracyTestCases::ExecutionsController < Admin::Bots::BaseController
  include Replyable

  def create
    @results = collect_results!
    falsh.now.notice = 'テスト実行に成功しました。'
    render 'admin/bots/accuracy_test_cases/index'
  end

  private
    def collect_results!
      results = []
      ActiveRecord::Base.transaction do
        @chat = @bot.chats.create(guest_key: SecureRandom.hex(64))
        @bot.accuracy_test_cases.each do |accuracy_test_case|
          message = @chat.messages.create!(
            body: accuracy_test_case.question_text,
            speaker: 'guest',
          )
          bot_messages = receive_and_reply!(@chat, message)
          results += bot_messages
        end
        raise ActiveRecord::Rollback
      end
    rescue ActiveRecord::Rollback => e
      result
    end
end
