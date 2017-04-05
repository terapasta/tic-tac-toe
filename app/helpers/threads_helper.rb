module ThreadsHelper
  def role_filter_params(param = {})
    params = message_params
    params.merge param
  end

  def message_filter_params(param = {})
    params = role_params
    params.merge param
  end

  private
    def message_params
      params.slice(:filter, :good, :bad, :marked)
    end

    def role_params
      params.slice(:normal)
    end
end
