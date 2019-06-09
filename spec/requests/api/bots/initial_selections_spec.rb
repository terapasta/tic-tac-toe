require 'rails_helper'

RSpec.describe 'Initial Selections', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:other_bot) do
    create(:bot)
  end

  let!(:question_answers) do
    create_list(:question_answer, 6, bot: bot)
  end

  let!(:other_question_answers) do
    create_list(:question_answer, 2, bot: other_bot)
  end

  let!(:initial_selections) do
    3.times.map do |n|
      bot.initial_selections.create(question_answer: question_answers[n])
    end
  end

  let(:response_json) do
    JSON.parse(response.body)
  end

  describe 'GET /api/bots/:bot_token/initial_selections' do
    it 'returns all initial selections' do
      get "/api/bots/#{bot.token}/initial_selections"
      response_json['initialSelections'].tap do |selections|
        expect(selections[0]['id']).to eq(initial_selections[0].id)
        expect(selections[1]['id']).to eq(initial_selections[1].id)
        expect(selections[2]['id']).to eq(initial_selections[2].id)
      end
    end
  end

  describe 'POST /api/bots/:bot_token/initial_selections' do
    context 'when initial selections aren\'t over the limit' do
      it 'creates a new initial selection' do
        expect{
          post "/api/bots/#{bot.token}/initial_selections", {
            params: { question_answer_id: question_answers[3].id }
          }
        }.to change(InitialSelection, :count).by(1)
      end
    end

    context 'when already initial selections have reached the limit' do
      before do
        (Bot::MaxInitialSelectionsCount - initial_selections.count).times do |n|
          bot.initial_selections.create(question_answer: question_answers[initial_selections.count + n])
        end
      end

      it 'doesn\'t create a new initial selection' do
        expect{
          post "/api/bots/#{bot.token}/initial_selections", {
            params: { question_answer_id: question_answers.last.id }
          }
          bot.reload
        }.to_not change(bot.initial_selections, :count)
      end
    end

    context 'when sending the question_answer_id of the other bot' do
      it 'doesn\'t create a new initial selection' do
        expect{
          post "/api/bots/#{bot.token}/initial_selections", {
            params: { question_answer_id: other_question_answers.first.id }
          }
          bot.reload
        }.to_not change(bot.initial_selections, :count)
      end
    end
  end

  describe 'DELETE /api/bots/:bot_token/initial_selections/:id' do
    it 'deletes the sepecified initial_selection' do
      expect{
        delete "/api/bots/#{bot.token}/initial_selections/#{bot.initial_selections.first.id}"
        bot.reload
      }.to change(bot.initial_selections, :count)
    end
  end

  describe 'PUT /api/bots/:bot_token/initial_selections/:id/move_higher' do
    it 'moves the specified record to higher position' do
      bot.initial_selections.last.tap do |initial_selection|
        expect{
          put "/api/bots/#{bot.token}/initial_selections/#{initial_selection.id}/move_higher"
          initial_selection.reload
        }.to change(initial_selection, :position).to(2).from(3)
      end
    end
  end

  describe 'PUT /api/bots/:bot_token/initial_selections/:id/move_lower' do
    it 'moves the specified record to lower position' do
      bot.initial_selections.first.tap do |initial_selection|
        expect{
          put "/api/bots/#{bot.token}/initial_selections/#{initial_selection.id}/move_lower"
          initial_selection.reload
        }.to change(initial_selection, :position).to(2).from(1)
      end
    end
  end
end