class SendAnswerFailedMailService
  def initialize(message, current_user, task)
    @message = message
    @current_user = current_user
    @task = task
  end

  def send_mail
    return if @current_user

    if @message.bot? && @message.answer_failed?
      AnswerFailedMailer.create(@message, @task).deliver_later
    end
  end
end
