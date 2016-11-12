module TrainingsHelper
  def training_last_message_anchor(messages, message, id:)
    "<span id=\"#{id}\" />".html_safe if messages.last == message
  end
end
