require 'rails_helper'

RSpec.describe DecisionBranch, type: :model do
  let!(:bot) do
    create(:bot)
  end

  let!(:question_answers) do
    create_list(:question_answer, 2)
  end

  let!(:decision_branch) do
    create(:decision_branch,
      bot: bot,
      question_answer: question_answers.first
    )
  end

  let!(:another_decision_branch) do
    create(:decision_branch,
      bot: bot,
      question_answer: question_answers.first
    )
  end

  describe 'serialization' do
    subject do
      DecisionBranchSerializer.new(decision_branch).as_json
    end

    context 'when has answer' do
      it do
        is_expected.to eq({
          id: decision_branch.id,
          body: decision_branch.body,
          answer: decision_branch.answer,
          question_answer_id: question_answers.first.id,
          created_at: decision_branch.created_at,
          parent_decision_branch_id: nil,
          answer_link: nil,
          child_decision_branches: [],
          position: 1,
          answer_files: []
        })
      end
    end

    context 'when has answer_link as dest_question_answer' do
      before do
        decision_branch.create_answer_link(
          answer_record_type: 'QuestionAnswer',
          answer_record_id: question_answers.second.id
        )
      end

      let!(:child_decision_branch) do
        create(:decision_branch,
          question_answer_id: question_answers.second.id
        )
      end

      it do
        is_expected.to eq({
          id: decision_branch.id,
          body: decision_branch.body,
          answer: question_answers.second.answer,
          question_answer_id: question_answers.first.id,
          created_at: decision_branch.created_at,
          parent_decision_branch_id: nil,
          answer_link: {
            answer_record_id: question_answers.second.id,
            answer_record_type: 'QuestionAnswer'
          },
          child_decision_branches: [
            child_decision_branch
          ],
          position: 1,
          answer_files: []
        })
      end
    end

    context 'when has answer_link as dest_decision_branch' do
      before do
        decision_branch.create_answer_link(
          answer_record_type: 'DecisionBranch',
          answer_record_id: another_decision_branch.id
        )
      end

      let!(:child_decision_branch) do
        create(:decision_branch,
          parent_decision_branch_id: another_decision_branch.id
        )
      end

      it do
        is_expected.to eq({
          id: decision_branch.id,
          body: decision_branch.body,
          answer: another_decision_branch.answer,
          question_answer_id: question_answers.first.id,
          created_at: decision_branch.created_at,
          parent_decision_branch_id: nil,
          answer_link: {
            answer_record_id: another_decision_branch.id,
            answer_record_type: 'DecisionBranch'
          },
          child_decision_branches: [
            child_decision_branch
          ],
          position: 1,
          answer_files: []
        })
      end
    end
  end
end