require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:bot) do
    create(:bot)
  end

  let(:chat) do
    create(:chat, bot: bot)
  end

  describe 'scope' do
    describe 'has_multiple_messages' do
      subject do
        Chat.has_multiple_messages.find_by(id: chat.id)
      end

      let!(:bot_message_greeting) do
        create(:message, chat: chat, speaker: 'bot', body: 'hello')
      end

      context '1件しかメッセージがない場合' do
        it 'メッセージは取得できないこと' do
          expect(subject.present?).not_to be
        end
      end

      context '2件のメッセージがある場合' do
        let!(:guest_message_question) do
          create(:message, chat: chat)
        end

        it 'メッセージを取得できること' do
          expect(subject.present?).to be
        end

        it '取得できる結果クラスはchatモデルであること' do
          expect(subject.kind_of?(Chat)).to be
        end
      end

      context '対話が繰り返されたメッセージがある場合(3件以上のメッセージ）' do
        let (:count) do
          2
        end

        let!(:guest_message_questions) do
          create_list(:message, count, chat: chat)
        end

        let!(:bot_message_answers) do
          create_list(:message, count, chat: chat, speaker: 'bot')
        end

        it '対話セット数はゲストメッセージと同数であること' do
          # 質問1つに回答が1つ返ってきた状態を対話数とカウントするのでguestの質問数=対話数とみなす。
          expect(subject.messages.guest.count).to eq(count)
        end
      end
    end
  end

  describe '#classified_pairs_messages' do
    let!(:bot) do
      create(:bot)
    end
  
    let!(:chat) do
      create(:chat, bot: bot)
    end

    let!(:messages) do
      first = chat.messages.create(speaker: :bot)
      [
        first,
        chat.messages.create(speaker: :guest, id: first.id + 1), # 1
        chat.messages.create(speaker: :bot, id: first.id + 2), # 2
        chat.messages.create(speaker: :guest, id: first.id + 3), # 3
        chat.messages.create(speaker: :bot, id: first.id + 4), # 4
        chat.messages.create(speaker: :guest, id: first.id + 6), # 5 わざとidを一つ飛ばす
        chat.messages.create(speaker: :guest, id: first.id + 7), # 6 わざとguestを連続させる
        chat.messages.create(speaker: :guest, id: first.id + 8), # 7
        chat.messages.create(speaker: :bot, id: first.id + 9) # 8
      ]
    end

    it '正しく質問と回答のペアに分類する' do
      expect(chat.classified_pair_messages).to eq([
        [messages[1], messages[2]],
        [messages[3], messages[4]],
        [messages[5]],
        [messages[6]],
        [messages[7], messages[8]]
      ])
    end
  end
end
