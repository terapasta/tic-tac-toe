class MessageSerializer < ActiveModel::Serializer
  attributes :id, :speaker, :rating, :created_at, :body, :icon_image_url
  has_one :answer

  def icon_image_url
    case object.speaker
    when 'guest'
      ActionController::Base.helpers.asset_path('silhouette.png')
    when 'bot'
      object.chat.bot.image_url(:thumb)
    end
  end
end
