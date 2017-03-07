require 'rails_helper'

RSpec.describe Bot do
  let!(:owner) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: owner)
  end

  describe 'chats association' do
    let!(:chats) do
      create_list(:chat, 2, bot: bot)
    end

    describe '#find_last_by!(guest_key)' do
      before do
        bot.chats.first.tap do |chat|
          chat.update(guest_key: 'sample guest key')
        end
      end

      subject do
        bot.chats.find_last_by!(guest_key)
      end

      context 'when exists' do
        let(:guest_key) do
          'sample guest key'
        end

        it "returns target chat" do
          expect(subject).to eq(bot.chats.first)
        end
      end

      context 'when not exists' do
        let(:guest_key) do
          'invalid guest key'
        end

        it 'raises error' do
          expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
