module GuestKeyUsable
  extend ActiveSupport::Concern

  private
    def set_guest_key
      if guest_key.blank?
        cookies[:guest_key] = {
          value: SecureRandom.hex(64)[0...255],
          path: '/',
          expires: 45.days.from_now
        }
      end
    end

    def guest_key
      cookies[:guest_key]
    end
end
