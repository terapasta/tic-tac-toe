require 'rails_helper'

RSpec.describe 'SubQuestions spec', type: :request do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:sub_questions) do
    create_list(:sub_question, 3, question_answer: question_answer)
  end

  let(:serialized_sub_questions) do
    sub_questions.map{ |sq|
      { 'question' => sq.question }
    }
  end

  let(:endpoint_namespace) do
    "/api/bots/#{bot.id}/question_answers/#{question_answer.id}"
  end

  before do
    login_as(user, scope: :user)
  end

  describe 'GET /api/bots/:bot_id/question_answers/:question_answer_id/sub_questions' do
    before do
      get "#{endpoint_namespace}/sub_questions"
    end

    subject do
      JSON.parse(response.body)['subQuestions']
    end

    it { is_expected.to match_array(serialized_sub_questions) }
  end

  describe 'POST /api/bots/:bot_id/question_answers/:question_answer_id/sub_questions' do
    subject do
      lambda do
        post "#{endpoint_namespace}/sub_questions", params: sub_question_params
      end
    end

    context 'when valid params' do
      let(:sub_question_params) do
        { sub_question: { question: 'example text' } }
      end

      it { is_expected.to change(SubQuestion, :count).by(1) }
    end

    context 'when invalid params' do
      let(:sub_question_params) do
        { sub_question: {} }
      end

      it { is_expected.to_not change(SubQuestion, :count) }
    end
  end

  describe 'DELETE /api/bots/:bot_id/question_answers/:question_answer_id/sub_questions/:id' do
    subject do
      lambda do
        delete "#{endpoint_namespace}/sub_questions/#{sub_questions.first.id}"
      end
    end

    it { is_expected.to change(SubQuestion, :count).by(-1) }
  end
end