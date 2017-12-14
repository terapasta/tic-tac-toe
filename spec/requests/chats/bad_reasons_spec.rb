require 'rails_helper'

RSpec.describe 'BadReasons', type: :request do
  describe 'POST /embed/:token/chats/messages/:message_id/bad_reasons' do
    let!(:bot) do
      create(:bot)
    end

    let!(:chat) do
      create(:chat, bot: bot)
    end

    let!(:message) do
      create(:message, chat: chat)
    end

    context 'when body param is not empty' do
      it 'returns 201 status' do
        post "/embed/#{bot.token}/chats/messages/#{message.id}/bad_reasons", params: { bad_reason: { body: 'hogehoge' } }
        expect(response.status).to eq(201)
      end
    end
  end
end