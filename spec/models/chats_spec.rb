require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:bot) do
    create(:bot)
  end

  let(:chat) do
    create(:chat, bot: bot)
  end

  let(:bot_message_greeting) do
    create(:message, chat: chat, speaker: 'bot', body: 'hello')
  end

  let(:bot_message_answer1) do
    create(:message, chat: chat, speaker: 'bot')
  end

  let(:bot_message_answer2) do
    create(:message, chat: chat, speaker: 'bot')
  end

  let(:guest_message_question1) do
    create(:message, chat: chat)
  end

  let(:guest_message_question2) do
    create(:message, chat: chat)
  end

  describe 'scope' do
    context 'has_multiple_messages' do
      it '1件しかメッセージがないchatモデルは取得できないこと' do
        bot_message_greeting

        expect(Chat.has_multiple_messages.find_by(chat.id).present?).not_to eq(true)
      end

      it '2件以上のメッセージがあるchatモデルを取得できること' do
        bot_message_greeting
        guest_message_question1

        expect(Chat.has_multiple_messages.find_by(chat.id).present?).to eq(true)
      end

      it '取得できる結果はchatモデルであること' do
        bot_message_greeting
        guest_message_question1

        expect(Chat.has_multiple_messages.find(chat.id).kind_of?(Chat)).to eq(true)
      end

      it '取得できる結果に対話セット数を含むこと' do
        bot_message_greeting
        guest_message_question1

        expect(Chat.has_multiple_messages.find(chat.id).has_attribute?(:exchanging_messages_count)).to eq(true)
      end

      it '取得できる結果に対話セット数はゲストメッセージと同数であること' do
        # 質問1つに回答が1つ返ってきた状態を対話数とカウントするのでguestの質問数=対話数とみなす。
        bot_message_greeting
        guest_message_question1
        bot_message_answer1
        guest_message_question2
        bot_message_answer2

        expect(Chat.has_multiple_messages.find(chat.id)[:exchanging_messages_count]).to eq(2)
      end
    end
  end
end
