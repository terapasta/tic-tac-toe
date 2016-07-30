class Conversation::Switcher
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def responder(message, states = {})
    if Service.contact.last.try(:enabled?) && (message.contact? || transision_to_contact?(message))
      Conversation::Contact.new(message, states)
    else
      Conversation::Bot.new(message)
    end
  end
  #
  def transision_to_contact?(message)
    last_answer = Message.bot.last.answer
    last_answer.transition_to == 'contact' && message.body == Conversation::Bot::POSITIVE_WORD
  end
end
