module IframeSupportable
  extend ActiveSupport::Concern

  class ExceededError < StandardError; end
  class FinishedTrialError < StandardError; end

  MyOpeHosts = %w(app.my-ope.net staging.my-ope.net localhost).freeze

  def iframe_support(bot)
    response.headers.except!('X-Frame-Options')
    origins = bot.allowed_hosts.map(&:to_origin).presence&.join(' ') || '*'
    csp = "frame-ancestors 'self' #{origins}"
    response.headers['X-Content-Security-Policy'] = csp
    response.headers['Content-Security-Policy'] = csp
    response.headers['P3P']= "CP='UNI CUR OUR'"

    request.headers['HTTP_REFERER'].tap do |ref|
      break if ref.blank? || MyOpeHosts.include?(URI.parse(ref).host)
      bot&.tutorial&.done_embed_chat_if_needed
    end
  end


  def prepare_iframe(bot)
    iframe_support bot
    fail ExceededError.new if policy(bot).exceeded_chats_count?
    fail FinishedTrialError if policy(bot).finished_trial?
  end
end
