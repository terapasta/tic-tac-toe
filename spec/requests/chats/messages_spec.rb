require 'rails_helper'

RSpec.describe 'chats/messages', type: :request do
  let!(:bot) do
    create(:bot, user: owner)
  end

  let!(:owner) do
    create(:user)
  end

  let!(:answer) do
    create(:answer, bot: bot)
  end

  let!(:decision_branches) do
    create_list(:decision_branch, 2, answer: answer, bot: bot)
  end

  let!(:next_answer) do
    create(:answer, bot: bot)
  end

  let(:chat_path) do
    "/embed/#{bot.token}/chats"
  end

  let(:res_json) do
    JSON.parse(response.body)
  end

  describe 'GET chats/messages' do
    before do
      get "#{chat_path}/new" # make guest_key and chat
      Message.last.tap do |m|
        m.answer = answer
        m.save
      end
      decision_branches.tapp.first.tap do |db|
        db.next_answer = next_answer
        db.save
      end
    end

    context 'when json format' do
      it 'returns json data' do
        get "#{chat_path}/messages.json"
        expect(res_json.tapp['messages'].is_a?(Array)).to be
        expect(res_json['messages'].first['answer']['id']).to be
        expect(res_json['meta']['totalPages']).to be_present
      end
    end
  end
end
