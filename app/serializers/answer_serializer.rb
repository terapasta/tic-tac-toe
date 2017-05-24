class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
  has_many :decision_branches
  has_many :answer_files
end
