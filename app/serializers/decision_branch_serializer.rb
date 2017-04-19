class DecisionBranchSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
  has_one :next_answer
end
