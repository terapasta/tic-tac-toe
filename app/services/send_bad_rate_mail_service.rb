class SendBadRateMailService
  def initialize(message, current_user, task)
    @message = message
    @current_user = current_user
    @task = task
  end

  def send_mail
    return if @current_user
    if @message.bot? && @message.rating&.bad?
      BadRateMailer.create(@message, task: @task).deliver_later(wait: 3.minutes)
    end
  end
end
