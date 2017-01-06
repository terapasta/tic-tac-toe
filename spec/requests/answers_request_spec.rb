require 'rails_helper'

RSpec.describe 'answers resources', type: :request do
  include RequestSpecHelper

  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:answer) do
    create(:answer, bot: bot)
  end

  before do
    sign_in user
  end

  describe 'GET /answers/:id.json' do
    it 'returns json of the answer record' do
      get "/bots/#{answer.bot.id}/answers/#{answer.id}.json"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["id"]).to eq(answer.id)
    end
  end

  describe 'PUT /answers/:id.json' do
    let(:answer_params) do
      {
        answer: {
          body: "updated body"
        }
      }
    end

    it 'updates the answer record' do
      put "/bots/#{answer.bot.id}/answers/#{answer.id}.json", answer_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["body"]).to eq(answer_params[:answer][:body])
    end
  end

  describe 'DELETE /answers/:id.json' do
    it 'deletes the answer record' do
      expect {
        delete "/bots/#{answer.bot.id}/answers/#{answer.id}.json"
        expect(response.status).to eq(204)
      }.to change(Answer, :count).by(-1)
    end
  end
end
