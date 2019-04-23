require 'rails_helper'

RSpec.describe '/api/bots/:token/chat_messages', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:chat) do
    create(:chat, bot_id: bot.id, guest_key: guest_key)
  end

  let(:guest_key) do
    'example guest key'
  end

  let(:message) do
    'example message'
  end

  describe 'POST /api/bots/:bot_token/chat_failed_messages' do
    it 'always creates failed message' do
      post "/api/bots/#{bot.token}/chat_failed_messages", params: {
        guest_key: guest_key,
        message: message
      }

      JSON.parse(response.body).tap do |json|
        json["message"]["body"].tap do |bot_message|
          expect(bot_message).to eq(DefinedAnswer.classify_failed_text)
        end
      end
    end
  end
end