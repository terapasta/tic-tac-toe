require 'rails_helper'

RSpec.describe AnswerLink, type: :model do
  let!(:bot) do
    create(:bot)
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:decision_branch) do
    create(:decision_branch, bot: bot, question_answer_id: question_answer.id)
  end

  let!(:child_decision_branch) do
    create(:decision_branch, bot: bot, parent_decision_branch_id: decision_branch.id)
  end

  let!(:another_question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:another_decision_branch) do
    create(:decision_branch, bot: bot, question_answer_id: another_question_answer.id)
  end

  describe 'association' do
    subject do
      answer_link.answer_record
    end

    context 'when link to toplevel answer' do
      let!(:answer_link) do
        create(:answer_link,
          decision_branch_id: decision_branch.id,
          answer_record_id: another_question_answer.id,
          answer_record_type: 'QuestionAnswer'
        )
      end

      it { is_expected.to eq(another_question_answer) }
      it { expect(decision_branch.dest_question_answer).to eq(another_question_answer) }
      it { expect(decision_branch.dest_decision_branch).to be_nil }
    end

    context 'when link to decision branch' do
      let!(:answer_link) do
        create(:answer_link,
          decision_branch_id: decision_branch.id,
          answer_record_id: another_decision_branch.id,
          answer_record_type: 'DecisionBranch'
        )
      end

      it { is_expected.to eq(another_decision_branch) }
      it { expect(decision_branch.dest_question_answer).to be_nil }
      it { expect(decision_branch.dest_decision_branch).to eq(another_decision_branch) }
    end
  end
end
