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
        Chat.has_multiple_messages.find_by(chat.id)
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

        it '取得結果に対話セット数を含むこと' do
          expect(subject.has_attribute?(:exchanging_messages_count)).to be
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
          expect(subject[:exchanging_messages_count]).to eq(count)
        end
      end
    end
  end
end
