class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
  has_many :decision_branches
end
