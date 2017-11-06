require 'rails_helper'

RSpec.describe '/api/bots/:token/chats', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let(:uid) do
    'yamagata@mofmofmof.onmicrosoft.com'
  end

  let(:name) do
    '山形 孝造'
  end

  def post_api_bot_chats
    post api_bot_chats_path(bot.token), params: {
      uid: uid,
      service_type: 'skype',
      name: name
    }
  end

  describe 'POST /api/bots/:token/chats' do
    context 'when first time' do
      it 'creates new user and chat records' do
        expect{
          expect{
            post_api_bot_chats
            expect(JSON.parse(response.body)).to eq(
              'chat' => {
                'guestKey' => Chat.last.guest_key
              }
            )
          }.to change(ChatServiceUser, :count).by(1)
        }.to change(Chat, :count).by(1)
      end
    end

    context 'when second time' do
      it 'not creates new user and chat records' do
        post_api_bot_chats
        expect{
          expect{ post_api_bot_chats }.to_not change(ChatServiceUser, :count)
        }.to_not change(Chat, :count)
      end
    end
  end
end