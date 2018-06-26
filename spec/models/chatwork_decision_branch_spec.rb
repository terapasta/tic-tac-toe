require 'rails_helper'

RSpec.describe ChatworkDecisionBranch, type: :model do
  describe '#generate_access_token' do
    subject do
      ChatworkDecisionBranch.new.generate_access_token
    end

    it { is_expected.to match /^[a-zA-Z0-9]{6}$/ }
  end

  describe '#set_access_token_if_needed' do
    let(:chatwork_decision_branch) do
      build(:chatwork_decision_branch)
    end

    subject do
      chatwork_decision_branch.set_access_token_if_needed
      chatwork_decision_branch.access_token
    end

    it { is_expected.to match /^[a-zA-Z0-9]{6}$/ }
  end
end
