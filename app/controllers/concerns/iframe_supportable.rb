module IframeSupportable
  extend ActiveSupport::Concern

  def iframe_support(bot)
    response.headers.except!('X-Frame-Options')
    origins = bot.allowed_hosts.map(&:to_origin).presence&.join(' ') || '*'
    csp = "frame-ancestors 'self' #{origins}"
    response.headers['X-Content-Security-Policy'] = csp
    response.headers['Content-Security-Policy'] = csp
  end
end
