class MessageSerializer < ActiveModel::Serializer
  attributes :id, :speaker, :rating, :created_at, :body, :icon_image_url, :answer_files, :answer_failed
  has_one :question_answer
  has_many :similar_question_answers, serializer: QuestionAnswerSerializer

  def icon_image_url
    case object.speaker
    when 'guest'
      ActionController::Base.helpers.asset_path('silhouette.png')
    when 'bot'
      object.chat.bot.image_url(:thumb)
    end
  end

  def answer_files
    object.question_answer&.answer_files.as_json(only: [:file, :file_size, :file_type])
  end
end
