module ThreadsHelper
  def role_filter_params(param = {})
    params.slice(:answer_failed, :good, :bad, :marked).merge(param)
  end
end
