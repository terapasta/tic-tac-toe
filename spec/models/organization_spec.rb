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

  describe 'before_1week_of_finishing_trial scope' do
    subject do
      Organization.before_1week_of_finishing_trial.to_a.include?(organization)
    end

    context 'when before 1 week of finishing trial day' do
      before do
        organization.update(plan: :trial)
        organization.update(trial_finished_at: 1.week.since.end_of_day)
      end

      it { is_expected.to be }
    end

    context 'when before 2 weeks of finishing trial day' do
      before do
        organization.update(plan: :trial)
        organization.update(trial_finished_at: 2.weeks.since.end_of_day)
      end

      it { is_expected.to_not be }
    end
  end
end
