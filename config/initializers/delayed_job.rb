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

# 非同期処理内で例外が発生した際も通知させる
module NotifyWhenDelayedJobFailed
  def handle_failed_job(job, error)
    super
    ExceptionNotifier.notify_exception(error)
  end
end
class Delayed::Worker
  prepend NotifyWhenDelayedJobFailed
end
