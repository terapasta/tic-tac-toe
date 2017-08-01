class ChatPolicy < ApplicationPolicy
  def show?
    new?
  end

  def new?
    return true if user.staff? || bot_owner?
    return true if record.bot.allowed_hosts.blank? && record.bot.allowed_ip_addresses.blank?
    if record.bot.allowed_hosts.any?
      return false if request.referer.blank?
      return false unless referer_is_allowed_origin?
    end
    if record.bot.allowed_ip_addresses.any?
      return authorized_ip_address?
    end
    true
  end

  def show_app?
    new?
  end

  def new_app?
    new?
  end

  private
    def referer_is_allowed_origin?
      ref = URI.parse(request.referer)
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
    end

    def bot_owner?
      user.id == record.bot&.user&.id
    end

    def authorized_ip_address?
      record.bot.allowed_ip_addresses.map(&:value).include?(request.remote_ip)
    end
end
