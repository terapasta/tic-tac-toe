class SendBadRateMailService
  def initialize(message, current_user)
    @message = message
    @current_user = current_user
  end

  def send_mail
    return if @current_user
    if @message.bot? && @message.rating&.bad?
      BadRateMailer.create(@message).deliver_later
    end
  end
end
