require 'rails_helper'

RSpec.describe '/api/bots/:bot_token/microsoft_credential', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:microsoft_credential) do
    create(:bot_microsoft_credential, bot_id: bot.id)
  end

  subject do
    JSON.parse(response.body)
  end

  describe 'GET /api/bots/:bot_token/microsoft_credential.json' do
    context 'when has line credential' do
      it 'returns line credential data' do
        get api_bot_microsoft_credential_path(bot.token)
        expect(subject['bot::MicrosoftCredential']['appId']).to eq(microsoft_credential.app_id)
        expect(subject['bot::MicrosoftCredential']['appPassword']).to eq(microsoft_credential.app_password)
      end
    end

    context 'when not has line credential' do
      before do
        bot.microsoft_credential.destroy
      end

      it 'returns not found error' do
        get api_bot_microsoft_credential_path(bot.token)
        expect(response.status).to eq(404)
      end
    end
  end
end
