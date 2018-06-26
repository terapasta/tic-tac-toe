class ChatworkDecisionBranch < ApplicationRecord
  include AccessTokenGeneratable

  belongs_to :chat
  belongs_to :decision_branch
  has_one :bot, through: :chat

  validates :access_token,
    presence: true,
    uniqueness: true

  before_validation :set_access_token_if_needed

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
