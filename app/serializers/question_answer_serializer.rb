class QuestionAnswerSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer
  has_many :decision_branches
  has_many :sub_questions
end
