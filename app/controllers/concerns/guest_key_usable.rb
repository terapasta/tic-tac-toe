module GuestKeyUsable
  extend ActiveSupport::Concern

  private
    def set_guest_key
      if cookies[:guest_key]&.length.to_i > 255 || guest_key.blank?
        cookies[:guest_key] = {
          value: make_guest_key,
          path: '/',
          expires: 45.days.from_now
        }
      end
    end

    def guest_key
      # NOTE:
      # guest_key はクエリパラメータ（params）、クッキー（cookies）、ヘッダ（headers）の順に評価する
      params[:guest_key] ||
      cookies[:guest_key] ||
      request.headers['X-Guest-Key']
    end

    def make_guest_key
      SecureRandom.hex(64)[0...255]
    end
end
