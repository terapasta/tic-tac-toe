Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

module Delayed
  class Job
    class << self
      # production.logなどにポーリングのUPDATE文が大量に吐かれるのを抑制する
      def reserve_with_log_silencer(worker, max_run_time = Worker.max_run_time)
        Rails.logger.silence { reserve_without_log_silencer(worker, max_run_time) }
      end
      alias_method_chain :reserve, :log_silencer
    end
  end
end
