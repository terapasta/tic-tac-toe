require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe '#self_and_deep_child_answers' do
    let!(:answer) do
      create(:answer)
    end

    let!(:decision_branches) do
      create_list(:decision_branch, 2, answer: answer)
    end

    let!(:child_answers) do
      decision_branches.map{ |db|
        db.next_answer = create(:answer)
        db.save
        db.next_answer
      }
    end

    let!(:child_answers_decision_branches) do
      child_answers.map{ |a|
        a.decision_branches = create_list(:decision_branch, 2)
      }.flatten
    end

    let!(:grandchild_answers) do
      child_answers_decision_branches.map{ |db|
        db.next_answer = create(:answer)
        db.save
        db.next_answer
      }
    end

    it 'returns self and all answers of subtree' do
      expect(answer.self_and_deep_child_answers).to match_array(
        [answer] + child_answers + grandchild_answers
      )
    end
  end
end
