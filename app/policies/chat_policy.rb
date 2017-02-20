class ChatPolicy < ApplicationPolicy
  def show?
    new?
  end

  def new?
    if request.referer.blank?
      user.staff? || user.id == record.bot.user.id || record.bot.allowed_hosts.blank?
    else
      referer_is_allowed_origin?
    end
  end

  private
    def referer_is_allowed_origin?
      ref = URI.parse(request.referer)
      if record.bot.allowed_hosts.any?
        record.bot.allowed_hosts
          .map(&:to_origin)
          .map(&Addressable::URI.method(:parse))
          .map { |o|
            is_match_host = if o.host.starts_with?('*.')
              ref.host.ends_with?(o.host.sub(/^\*\./, ''))
            else
              ref.host == o.host
            end
            is_match_host && ref.scheme == o.scheme
          }
          .include?(true)
        else
          true
        end
    end
end
