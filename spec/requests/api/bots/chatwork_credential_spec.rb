require 'rails_helper'

RSpec.describe '/api/bots/:bot_token/chatwork_credential', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:chatwork_credential) do
    create(:bot_chatwork_credential, bot_id: bot.id)
  end

  subject do
    JSON.parse(response.body)
  end

  describe 'GET /api/bots/:bot_token/chatwork_credential.json' do
    context 'when has chatwork credential' do
      it 'returns chatwork credential data' do
        get api_bot_chatwork_credential_path(bot.token)
        expect(subject['bot::ChatworkCredential']['apiToken']).to eq(chatwork_credential.api_token)
      end
    end

    context 'when not has chatwork credential' do
      before do
        bot.chatwork_credential.destroy
      end

      it 'returns not found error' do
        get api_bot_chatwork_credential_path(bot.token)
        expect(response.status).to eq(404)
      end
    end
  end
end