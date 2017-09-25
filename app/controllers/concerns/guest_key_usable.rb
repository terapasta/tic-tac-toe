module GuestKeyUsable
  extend ActiveSupport::Concern

  private
    def set_guest_key
      if cookies.encrypted[:guest_key].blank?
        cookies.encrypted[:guest_key] = {
          value: SecureRandom.hex(64),
          path: '/',
          expires: 45.days.from_now,
          secure: Rails.env.production?
        }
      end
    end

    def guest_key
      cookies.encrypted[:guest_key]
    end
end
