require 'rails_helper'

RSpec.describe '/api/bots/:bot_id/answers', type: :request do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:answers) do
    create_list(:answer, 2, bot: bot)
  end

  let(:response_json) do
    JSON.parse(response.body)
  end

  describe 'GET #index' do
    let(:resources) do
      "/api/bots/#{bot.id}/answers"
    end

    context 'when login as bot owner' do
      before do
        login_as(user, scope: :user)
      end

      it 'returns answers' do
        get resources
        expect(response_json['answers'].count).to eq(2)
      end
    end
  end
end
