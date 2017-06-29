class Admin::Bots::ExecutionsController < Admin::Bots::BaseController
  include Replyable

  def create!
    result = []
    ActiveRecord::Base.transaction do
      @chat = @bot.chats.create(guest_key: SecureRandom.hex(64))
      @bot.accuracy_test_cases.each do |accuracy_test_case|
        message = @chat.messages.create!(body: accuracy_test_case.question_text, speaker: 'guest', user_agent: request.env['HTTP_USER_AGENT'])
        receive_and_reply!(@chat, message)
      end
      raise ActiveRecord::Rollback
    end
    @chat.messages.each_with_index { |message, i|
      result.push(message) if i.odd?
    }
    redirect_to admin_bot_accuracy_test_cases_path(@bot), notice: "テスト実行に成功しました。"
  end
end
