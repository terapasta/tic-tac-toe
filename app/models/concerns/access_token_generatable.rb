module AccessTokenGeneratable
  extend ActiveSupport::Concern

  AccessTokenSeeds = [
    *(('a'..'z').to_a),
    *(('A'..'Z').to_a),
    *((0..9).to_a)
  ].freeze

  def generate_access_token(length = 6)
    length.times.map{ AccessTokenSeeds.sample }.join
  end
end