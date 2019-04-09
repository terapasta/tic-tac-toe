require 'rails_helper'

RSpec.describe '/api/bots/:token/chat_messages/:chat_message_id/rating.json', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:chat_service_user) do
    create(:chat_service_user, bot_id: bot.id, service_type: :skype).tap do |c|
      c.make_guest_key_if_needed!
    end
  end

  let!(:chat) do
    create(:chat, bot_id: bot.id, guest_key: chat_service_user.guest_key)
  end
  
  let!(:guest_message) do
    create(:message, chat_id: chat.id, speaker: :guest, body: 'example guest')
  end

  let!(:bot_message) do
    create(:message, chat_id: chat.id, speaker: :bot, body: 'example bot')
  end

  describe 'POST /api/bots/:token/chat_messages/:chat_message_id/rating' do
    context 'when rating not exists' do
      it 'creates a new rating' do
        expect{
          post "/api/bots/#{bot.token}/chat_messages/#{bot_message.id}/rating.json", {
            params: {
              rating: { level: 'good' },
              guest_key: chat_service_user.guest_key,
            }
          }
          expect(bot_message.rating).not_to be_nil
          expect(bot_message.rating.good?).to be
        }.to change(Rating, :count).by(1)
      end
    end

    context 'when rating exists' do
      before do
        bot_message.good!
      end

      it 'updates a rating' do
        expect{
          post "/api/bots/#{bot.token}/chat_messages/#{bot_message.id}/rating.json", {
            params: {
              rating: { level: 'bad' },
              guest_key: chat_service_user.guest_key,
            }
          }
          bot_message.reload
          expect(bot_message.rating).not_to be_nil
          expect(bot_message.rating.bad?).to be
        }.not_to change(Rating, :count)
      end
    end
  end
end