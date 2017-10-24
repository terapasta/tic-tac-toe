module ThreadsHelper
  def role_filter_params(param = {})
    params.permit(:answer_failed, :good, :bad, :marked).merge(param)
  end
end
