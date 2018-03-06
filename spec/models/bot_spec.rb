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

  describe 'HasSuggestMessage' do
    describe 'default has_suggests_message' do
      let(:bot) do
        build(:bot)
      end

      subject do
        bot.has_suggests_message
      end

      it { is_expected.to eq("{question}についてですね。 どのような質問ですか？ 以下から選択するか、もう少し詳しい内容を入力していただけますか？") }
    end

    describe '#render_has_suggests_message' do
      let(:bot) do
        build(:bot)
      end

      subject do
        bot.render_has_suggests_message('test')
      end

      it { is_expected.to eq("「test」についてですね。 どのような質問ですか？ 以下から選択するか、もう少し詳しい内容を入力していただけますか？") }
    end
  end

  describe '#change_token_and_set_demo_finished_time!' do
    subject do
      lambda do
        bot.change_token_and_set_demo_finished_time!
      end
    end

    it 'change token and set demo_finished_at' do      
      expect(subject)
        .to change{ bot.reload.token }
        .and change{ bot.reload.demo_finished_at }
    end
  end
end
