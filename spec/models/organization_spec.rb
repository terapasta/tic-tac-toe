require 'rails_helper'

RSpec.describe Organization, :type => :model do
  let!(:organization) do
    create(:organization, plan: :professional)
  end

  describe '#set_trial_finished_at_if_needed' do
    subject do
      lambda do
        organization.update(plan: 'trial')
        organization.reload
      end
    end

    context 'when change to trial from other' do
      it 'sets 2 months later datetime to traial_finished_at' do
        expect(subject).to change(organization, :trial_finished_at)
      end
    end
  end
end
