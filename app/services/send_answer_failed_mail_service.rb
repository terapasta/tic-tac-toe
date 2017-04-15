class SendAnswerFailedMailService
  def initialize(messages)
    @messages = messages
  end

  def send_mail
    @messages.each do |message|
      if message.bot? && message.answer_failed?
        AnswerFailedMailer.create(message).deliver_later
      end
    end
  end
end
