require 'rails_helper'

RSpec.describe '/api/bots/:bot_token/decision_branches/:id/answer_link', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:decision_branch) do
    create(:decision_branch, bot: bot, question_answer_id: question_answer.id)
  end

  let!(:another_question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:another_decision_branch) do
    create(:decision_branch, bot: bot, question_answer_id: another_question_answer.id)
  end

  let(:endpoint) do
    "/api/bots/#{bot.token}/decision_branches/#{decision_branch.id}/answer_link"
  end

  describe 'POST #create' do
    subject do
      lambda do
        post endpoint, params: {
          answer_link: {
            answer_record_id: another_question_answer.id,
            answer_record_type: 'QuestionAnswer'
          }
        }
      end
    end

    it { is_expected.to change(AnswerLink, :count).by(1) }
  end

  describe 'DELETE #destroy' do
    let!(:answer_link) do
      create(:answer_link,
        decision_branch_id: decision_branch.id,
        answer_record_id: another_question_answer.id,
        answer_record_type: 'QuestionAnswer'
      )
    end

    subject do
      lambda do
        delete endpoint
      end
    end

    it { is_expected.to change(AnswerLink, :count).by(-1) }
  end
end