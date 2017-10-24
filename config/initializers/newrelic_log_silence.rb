if Rails.env.production?
  # production.logなどにポーリングのselect文が大量に吐かれるのを抑制する
  module PollWithLogSilencer
    def poll
      Rails.logger.silence { super }
    end
  end
  NewRelic::Agent::Samplers::DelayedJobSampler.prepend(PollWithLogSilencer)

  # module NewRelic
  #   module Agent
  #     module Samplers
  #       class DelayedJobSampler
  #         def poll_with_log_silencer
  #           Rails.logger.silence { poll_without_log_silencer }
  #         end
  #         alias_method_chain :poll, :log_silencer
  #       end
  #     end
  #   end
  # end
end
