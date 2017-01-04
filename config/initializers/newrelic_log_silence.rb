module NewRelic
  module Agent
    module Samplers
      class DelayedJobSampler
        # production.logなどにポーリングのselect文が大量に吐かれるのを抑制する
        def poll_with_log_silencer
          Rails.logger.silence { poll_without_log_silencer }
        end
        alias_method_chain :poll, :log_silencer
      end
    end
  end
end
