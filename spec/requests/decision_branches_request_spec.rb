require 'rails_helper'

RSpec.describe 'decision_branch resources', type: :request do
  include RequestSpecHelper

  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:decision_branch) do
    create(:decision_branch, bot: bot)
  end

  before do
    sign_in user
  end

  describe 'GET /decision_branches/:id.json' do
    it 'returns json of the answer record' do
      get "/bots/#{decision_branch.bot.id}/decision_branches/#{decision_branch.id}.json"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["id"]).to eq(decision_branch.id)
    end
  end

  describe 'PUT /descision_branches/:id.json' do
    let(:decision_branch_params) do
      {
        decision_branch: {
          body: "updated body"
        }
      }
    end

    it 'updates the decision_branch record' do
      put "/bots/#{decision_branch.bot.id}/decision_branches/#{decision_branch.id}.json", decision_branch_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["body"]).to eq(decision_branch_params[:decision_branch][:body])
    end
  end

  describe 'DELETE /decision_branches/:id.json' do
    it 'deletes the decision_branch record' do
      expect {
        delete "/bots/#{bot.id}/decision_branches/#{decision_branch.id}.json"
        expect(response.status).to eq(204)
      }.to change(DecisionBranch, :count).by(-1)
    end
  end
end
