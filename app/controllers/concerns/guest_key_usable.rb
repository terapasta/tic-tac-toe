module GuestKeyUsable
  extend ActiveSupport::Concern

  included do
    helper_method :guest_key
  end

  private
    def set_guest_key
      # 不正な guest_key が渡された場合は空文字列が返る
      if guest_key.blank?
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
      gk = params[:guest_key] ||
           cookies[:guest_key] ||
           request.headers['X-Guest-Key']

      # guest_key が正しいフォーマットの場合のみ guest_key として使用
      valid_key?(gk) ? gk : ""
    end

    def valid_key?(key)
      if key.present?
        key.match(/^[0-9a-f]{128}$/).present?
      else
        false
      end
    end

    def make_guest_key
      # 2 * 64文字の 16進数
      # https://docs.ruby-lang.org/ja/latest/class/SecureRandom.html#S_HEX
      SecureRandom.hex(64)[0...255]
    end
end
