class Jwt
  HMAC_SECRET = Rails.application.secrets[:secret_key_base]
  ALGORITHM = 'HS256'

  class InvalidUserError < StandardError; end
  class InvalidTokenError < StandardError; end

  def self.generate(user)
    unless user.persisted?
      fail InvalidUserError.new('The user is not saved')
    end
    unless user.is_a?(User)
      fail InvalidUserError.new('The user is not an instance of User model')
    end
    payload = {
      iss: Rails.env,
      exp: 2.hours.since.to_i,
      iat: Time.current.to_i,
      user_id: user.id,
    }
    JWT.encode(payload, HMAC_SECRET, ALGORITHM)
  end

  def self.parse(token)
    JWT.decode(token, HMAC_SECRET, true, { algorithm: ALGORITHM })[0].tap do |it|
      if it['iss'] != Rails.env
        fail InvalidTokenError.new("The iss '#{it['iss']}' does not match with '#{Rails.env}'")
      end
    end
  end
end