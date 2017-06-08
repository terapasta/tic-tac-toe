require 'rails_helper'

RSpec.describe '/api/bots', type: :request do
  let!(:staff) do
    create(:user, :staff)
  end

  let!(:user) do
    create(:user)
  end

  let!(:other_user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:other_bot) do
    create(:bot, user: other_user)
  end

  let(:response_json) do
    JSON.parse(response.body)
  end

  describe 'GET #show' do
    let(:resource) do
      "/api/bots/#{target_bot.id}.json"
    end

    context 'when login as normal' do
      before { login_as(user, scope: :user)}

      context 'when get own bot' do
        let(:target_bot) { bot }
        it 'returns bot' do
          get resource
          expect(response_json["bot"]["id"]).to eq(bot.id)
        end
      end

      context 'when get other bot' do
        let(:target_bot) { other_bot }
        it 'returns error' do
          get resource
          expect(response.status).to eq(403)
        end
      end
    end

    context 'when login as staff' do
      before { login_as(user, scope: :user) }
      let(:target_bot) { bot }
      it 'returns bot' do
        get resource
        expect(response_json["bot"]["id"]).to eq(bot.id)
      end
    end
  end
end
