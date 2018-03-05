class DelayedJob < ActiveRecord::Base
  serialize :handler

  def job_class
    handler&.job_data&.dig('job_class')&.constantize
  end

  def arguments
    handler&.job_data&.dig('arguments')
  end
end