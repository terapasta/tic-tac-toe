require 'rails_helper'

RSpec.describe AnswerFile, :type => :model do
  describe 'associations' do
    describe 'belongs to question_answer' do
      let!(:question_answer) do
        create(:question_answer, bot: create(:bot))
      end

      let!(:answer_file) do
        create(:answer_file, question_answer: question_answer)
      end

      subject do
        answer_file.question_answer
      end

      it { is_expected.to eq(question_answer) }
    end

    describe 'belongs to decision_branch' do
      let!(:decision_branch) do
        create(:decision_branch, bot: create(:bot))
      end

      let!(:answer_file) do
        create(:answer_file, decision_branch: decision_branch)
      end

      subject do
        answer_file.decision_branch
      end

      it { is_expected.to eq(decision_branch) }
    end
  end
end
