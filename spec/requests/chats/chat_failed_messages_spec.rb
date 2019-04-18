require 'rails_helper'

RSpec.describe '/embed/:token/chats/chat_messages', type: :request do
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

  describe 'POST /embed/:bot_token/chats/chat_failed_messages' do
    it 'always creates failed message' do
      post "/embed/#{bot.token}/chats/chat_failed_messages", params: {
        guest_key: guest_key,
        message: message
      }

      JSON.parse(response.body).tap do |json|
        json['messages'][0].tap do |guest_message|
          expect(guest_message['body']).to eq(message)
        end
        json['messages'][1].tap do |bot_message|
          expect(bot_message['body']).to eq(DefinedAnswer.classify_failed_text)
          expect(bot_message['answerFailed']).to be
        end
      end
    end
  end
end