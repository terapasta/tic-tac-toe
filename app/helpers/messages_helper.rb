module MessagesHelper
  def answer_failed_destroyable?(message)
    message.answer_failed? && message.answer_failed_by_user?
  end
end
