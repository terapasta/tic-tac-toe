require 'rails_helper'

RSpec.describe '/api/bots/:bot_id/decision_branches' do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:decision_branches) do
    create_list(:decision_branch, 3, question_answer: question_answer, bot: bot)
  end

  before do
    login_as(user, scope: :user)
  end

  describe 'PUT /api/bots/:bot_id/decision_branches/:decision_branch_id/position/higher' do
    subject do
      lambda do
        put "/api/bots/#{bot.id}/decision_branches/#{decision_branch.id}/position/higher"
      end
    end

    context 'when first item' do
      let(:decision_branch) do
        decision_branches.first
      end

      it 'does not move to higher position' do
        expect(subject).to_not change{decision_branch.reload.position}
      end
    end

    context 'when not first item' do
      let(:decision_branch) do
        decision_branches.second
      end

      it 'does move to higher position' do
        expect(subject).to change{decision_branch.reload.position}.to(1).from(2)
      end
    end
  end

  describe 'PUT /api/bots/:bot_id/decision_branches/:decision_branch_id/position/lower' do
    subject do
      lambda do
        put "/api/bots/#{bot.id}/decision_branches/#{decision_branch.id}/position/lower"
      end
    end

    context 'when last item' do
      let(:decision_branch) do
        decision_branches.last
      end

      it 'does not move to lower position' do
        expect(subject).to_not change{decision_branch.reload.position}
      end
    end

    context 'when not last item' do
      let(:decision_branch) do
        decision_branches.first
      end

      it 'does move to lower position' do
        expect(subject).to change{decision_branch.reload.position}.to(2).from(1)
      end
    end
  end
end