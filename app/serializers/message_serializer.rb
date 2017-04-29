class MessageSerializer < ActiveModel::Serializer
  attributes :id, :speaker, :rating, :created_at, :body, :icon_image_url
  has_one :answer
  has_many :similar_question_answers, serializer: QuestionAnswerSerializer

  def icon_image_url
    case object.speaker
    when 'guest'
      ActionController::Base.helpers.asset_path('silhouette.png')
    when 'bot'
      object.chat.bot.image_url(:thumb)
    end
  end
end
