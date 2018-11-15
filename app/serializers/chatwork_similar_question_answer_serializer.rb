class ChatworkSimilarQuestionAnswerSerializer < ActiveModel::Serializer
  attributes :access_token, :question

  def question
    object.question.presence || object.question_answer&.question || ''
  end
end