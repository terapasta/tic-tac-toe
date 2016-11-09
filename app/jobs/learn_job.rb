class LearnJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.debug('hogehoge')
  end
end
