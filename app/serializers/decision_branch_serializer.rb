class DecisionBranchSerializer < ActiveModel::Serializer
  attributes :id, :body, :answer, :question_answer_id, :created_at, :parent_decision_branch_id
  has_many :child_decision_branches
end
