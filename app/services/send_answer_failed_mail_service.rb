class SendAnswerFailedMailService
  def initialize(messages, current_user)
    @messages = messages
    @current_user = current_user
  end

  def send_mail
    return if @current_user
    @messages.each do |message|
      if message.bot? && message.answer_failed?
        AnswerFailedMailer.create(message).deliver_later
      end
    end
  end
end
