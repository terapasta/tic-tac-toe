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
    let(:resource) do
      "/api/public_bots/#{bot.token}"
    end

    it 'returns bot data' do
      get resource
      expect(response).to be_success
      json_data['bot'].tap do |bot_data|
        expect(bot_data.keys).to match_array(['name', 'image'])
      end
    end
  end
end
