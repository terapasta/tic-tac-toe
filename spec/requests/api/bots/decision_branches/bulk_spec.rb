require 'rails_helper'

RSpec.describe 'DELETE /api/bots/:bot_id/decision_branches/bulk', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:user) do
    create(:user)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.bot_ownerships.create(bot: bot)
      org.user_memberships.create(user: user)
    end
  end

  let!(:decision_branches) do
    create_list(:decision_branch, 3, bot: bot)
  end

  before do
    login_as user, scope: :user
  end

  let(:endpoint) do
    "/api/bots/#{bot.id}/decision_branches/bulk"
  end

  subject do
    lambda do
      delete endpoint, params: { decision_branch_ids: decision_branch_ids }
    end
  end

  context 'when decision_branch_ids is exists' do
    let(:decision_branch_ids) { decision_branches.map(&:id) }
    it { is_expected.to change(DecisionBranch, :count).by(-3) }
  end

  context 'when decision_branch_ids is blank' do
    let(:decision_branch_ids) { [] }

    it 'returns 404 response' do
      subject.call
      expect(response.status).to eq(404)
    end
  end

  context 'when decision_branch_ids is invalid' do
    let(:decision_branch_ids) { decision_branches.map(&:id).map{ |id| id + 100 } }

    it 'returns 404 response' do
      subject.call
      expect(response.status).to eq(404)
    end
  end
end