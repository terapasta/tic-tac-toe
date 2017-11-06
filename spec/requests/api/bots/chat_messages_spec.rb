require 'rails_helper'

RSpec.describe '/api/bots/:token/chat_messages', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:chat_service_user) do
    create(:chat_service_user, bot_id: bot.id, service_type: :skype).tap do |c|
      c.make_guest_key_if_needed!
    end
  end

  let!(:chat) do
    create(:chat, bot_id: bot.id, guest_key: chat_service_user.guest_key)
  end

  let(:message) do
    'ラーメンの話'
  end

  let(:answer_message) do
    create(:message,
      speaker: :bot,
      body: question_answer.question,
      question_answer: question_answer,
      chat: chat,
    )
  end

  before do
    allow_any_instance_of(Api::Bots::ChatMessagesController).to receive(:receive_and_reply!).and_return([answer_message])
  end

  def post_api_bot_chat_messages
    post api_bot_chat_messages_path(bot.token), params: {
      guest_key: chat_service_user.guest_key,
      message: message,
    }
  end

  describe 'POST /api/bots/:token/chat_messages' do
    context 'when answer has decision_branches' do
      let(:question_answer) do
        create(:question_answer, bot: bot)
      end
      it 'create new message record' do
        expect{
          post_api_bot_chat_messages
          expect(JSON.parse(response.body)['messages'].size).to eq 2
        }.to change(Message, :count).by(1)
      end
    end

    context 'when answer does not have decision_branches' do
      let(:question_answer) do
        create(:question_answer, :with_decision_branches, bot: bot)
      end
      it 'create new message record' do
        expect{
          post_api_bot_chat_messages
          expect(JSON.parse(response.body)['messages'].size).to eq 2
        }.to change(Message, :count).by(1)
      end
    end
  end
end