class SendBadRateMailService
  def initialize(message, current_user, task)
    @message = message
    @current_user = current_user
    @task = task
  end

  def send_mail
    return if @current_user
    if @message.bot? && @message.rating&.bad?
      # Note: bad評価理由の入力があった場合に一緒に通知したいので、3分待ってからメールを送信する
      BadRateMailer.create(@message, task: @task).deliver_later(wait: 3.minutes)
    end
  end
end
