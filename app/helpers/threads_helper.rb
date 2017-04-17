module ThreadsHelper
  def role_filter_params(param = {})
    message_params.merge param
  end

  def message_filter_params(param = {})
    role_params.merge param
  end

  private
    def message_params
      @message_params ||= params.slice(:filter, :good, :bad, :answer_marked)
    end

    def role_params
      @role_params ||= params.slice(:normal)
    end
end
