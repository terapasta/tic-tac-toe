module ChatworkSelection
  extend ActiveSupport::Concern
  include AccessTokenGeneratable

  included do
    belongs_to :chat
    has_one :bot, through: :chat

    validates :access_token,
      presence: true,
      uniqueness: true

    validates :room_id,
      presence: true

    validates :from_account_id,
      presence: true

    before_validation :set_access_token_if_needed
  end

  def set_access_token_if_needed
    return if access_token.present?
    new_access_token = generate_access_token

    if self.class.exists?(access_token: new_access_token)
      set_access_token_if_needed
    else
      self.access_token = new_access_token
    end
  end
end