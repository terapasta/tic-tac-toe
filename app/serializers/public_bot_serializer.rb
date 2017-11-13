class PublicBotSerializer < ActiveModel::Serializer
  attributes :name, :image, :widget_subtitle

  def widget_subtitle
    object.widget_subtitle.presence || Bot::DefaultWidgetSubtitle
  end
end
