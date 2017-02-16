class ChatPolicy < ApplicationPolicy
  def show?
    new?
  end

  def new?
    user.staff? || user.id == record.bot.user.id || referer_is_allowed_origin?
  end

  private
    def referer_is_allowed_origin?
      ref = URI.parse(request.referer)
      record.bot.allowed_hosts
        .map(&:to_origin)
        .map(&Addressable::URI.method(:parse))
        .map { |o|
          o.scheme == ref.scheme &&
          o.host.sub(/^\*\./, '') == ref.host
        }
        .exclude?(false)
    end
end
