module IframeSupportable
  extend ActiveSupport::Concern

  module ClassMethods
    def iframe_support(*action_names)
      define_method :iframe_support_action_names do
        action_names.map(&:to_s)
      end
      before_action :set_iframe_support_headers
    end
  end

  private
    def set_iframe_support_headers
      if iframe_support_action_names.include?(params[:action])
        response.headers.except!('X-Frame-Options')
        Rails.configuration.x.allow_iframe_origins.tap do |origins|
          csp = "frame-ancestors 'self' #{origins.join(' ')}"
          response.headers['X-Content-Security-Policy'] = csp
          response.headers['Content-Security-Policy'] = csp
        end
      end
    end
end