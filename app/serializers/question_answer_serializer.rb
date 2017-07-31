class QuestionAnswerSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer, :answer_id
  has_many :decision_branches
end
