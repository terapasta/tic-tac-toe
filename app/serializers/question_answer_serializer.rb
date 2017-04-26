class QuestionAnswerSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer_id
  has_one :answer
end
