class ChatPolicy < ApplicationPolicy
  def show?
    new?
  end

  def new?
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
