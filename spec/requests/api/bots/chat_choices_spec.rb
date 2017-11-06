require 'rails_helper'

RSpec.describe '/api/bots/:token/chat_choices', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:chat_service_user) do
    create(:chat_service_user, bot_id: bot.id, service_type: :skype).tap do |c|
      c.make_guest_key_if_needed!
    end
  end

  let!(:chat) do
    create(:chat, bot: bot, guest_key: chat_service_user.guest_key)
  end

  let!(:last_message) do
    create(:message, chat: chat)
  end

  let(:question_answer) do
    create(:question_answer, :with_decision_branches, bot: bot)
  end

  let(:decision_branch) {
    question_answer.decision_branches.first
  }

  let(:answer_message) do
    create(:message,
      speaker: :bot,
      body: question_answer.question,
      question_answer: question_answer,
      chat: chat,
    )
  end

  def post_api_bot_chat_choices
    post api_bot_chat_choices_path(bot.token, decision_branch.id), params: {
      guest_key: chat_service_user.guest_key,
    }
  end

  subject(:response_bot_message) do
    JSON.parse(response.body)
  end

  describe 'POST /api/bots/:token/chat_choices/:id' do
    it 'create new message records' do
      expect{
        post_api_bot_chat_choices
        expect(response_bot_message['message']['body']).to eq decision_branch.answer
      }.to change(Message, :count).by(2)
    end
  end
end