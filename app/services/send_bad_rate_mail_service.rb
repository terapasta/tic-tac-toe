class SendBadRateMailService
  def initialize(message)
    @message = message
  end

  def send_mail
    if @message.bot? && @message.bad?
      BadRateMailer.create(@message).deliver_later
    end
  end
end
