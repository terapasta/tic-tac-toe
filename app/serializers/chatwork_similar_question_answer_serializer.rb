class ChatworkSimilarQuestionAnswerSerializer < ActiveModel::Serializer
  attributes :access_token, :question

  def question
    object.question_answer&.question || ''
  end
end