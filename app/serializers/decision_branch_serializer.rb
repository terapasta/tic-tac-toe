class DecisionBranchSerializer < ActiveModel::Serializer
  attributes :id, :body, :answer, :question_answer_id, :created_at, :child_decision_branches
  has_one :next_answer
  has_many :child_decision_branches
end
