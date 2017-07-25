class ChatPolicy < ApplicationPolicy
  def show?
    return false if ip_address_authorization?(Bot.find(record.bot_id))
    new?
  end

  def new?
    return false if ip_address_authorization?(Bot.find(record.bot_id))
    return true if user.staff? || bot_owner? || record.bot.allowed_hosts.blank?
    return false if request.referer.blank?
    referer_is_allowed_origin?
  end

  def show_app?
    new?
  end

  def new_app?
    new?
  end

  def ip_address_authorization?(bot)
    return false if bot.allowed_ip_addresses.blank?
    return false if bot.allowed_ip_addresses.present? && bot.allowed_ip_addresses.map(&:value).include?(request.ip)
    true
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
end
