require 'rails_helper'

RSpec.describe '/api/public_bots', type: :request do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let(:json_data) do
    JSON.parse(response.body)
  end

  describe 'GET /api/public_bots/:token' do
    context 'when bot exists' do
      let(:resource) do
        "/api/public_bots/#{bot.token}"
      end

      it 'returns bot data' do
        get resource
        expect(response).to be_success
        json_data['bot'].tap do |bot_data|
          expect(bot_data.keys).to match_array(['name', 'image', 'widgetSubtitle'])
        end
      end
    end

    context 'when bot not exists' do
      let(:resource) do
        '/api/public_bots/hogehoge'
      end

      it 'returns bot data' do
        get resource
        expect(response.status).to eq(404)
        expect(json_data['error']).to be_present
      end
    end
  end
end
