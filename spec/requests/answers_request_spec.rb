require 'rails_helper'

RSpec.describe 'answers resources', type: :request do
  include RequestSpecHelper

  let!(:user) do
    create(:user)
  end

  let!(:answer) do
    create(:answer)
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
end
