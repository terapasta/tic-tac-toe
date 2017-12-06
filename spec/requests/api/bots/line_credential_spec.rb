require 'rails_helper'

RSpec.describe '/api/bots/:bot_token/line_credential', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:line_credential) do
    create(:bot_line_credential, bot_id: bot.id)
  end

  subject do
    JSON.parse(response.body)
  end

  describe 'GET /api/bots/:bot_token/line_credential.json' do
    it 'returns line credential data' do
      get api_bot_line_credential_path(bot.token)
      expect(subject['bot::LineCredential']['channelId']).to eq(line_credential.channel_id)
      expect(subject['bot::LineCredential']['channelSecret']).to eq(line_credential.channel_secret)
      expect(subject['bot::LineCredential']['channelAccessToken']).to eq(line_credential.channel_access_token)
    end
  end
end