class PublicBotSerializer < ActiveModel::Serializer
  attributes :name, :image, :widget_subtitle, :classify_failed_message

  def widget_subtitle
    object.widget_subtitle.presence || Bot::DefaultWidgetSubtitle
  end

  def classify_failed_message
    object.classify_failed_message_with_fallback
  end
end
