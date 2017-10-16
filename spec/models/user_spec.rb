require 'rails_helper'

RSpec.describe User do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:lite_organization) do
    create(:organization, plan: :lite)
  end

  let!(:standard_organization) do
    create(:organization, plan: :standard)
  end

  let!(:professional_organization) do
    create(:organization, plan: :professional)
  end

  describe '#ec_plan?' do
    subject do
      user.ec_plan?(bot)
    end

    before do
      organization.bot_ownerships.create(bot: bot)
      user.organization_memberships.create(organization: organization)
    end

    context 'when joined lite plan organization' do
      let(:organization) do
        lite_organization
      end

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when joined standard plan organization' do
      let(:organization) do
        standard_organization
      end

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when joined professional plan organization' do
      let(:organization) do
        professional_organization
      end

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end
end
