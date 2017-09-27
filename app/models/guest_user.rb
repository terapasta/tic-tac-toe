class GuestUser < ActiveRecord::Base
  validates :name,
    presence: true

  validates :email,
    email: true,
    allow_nil: true

  validates :guest_key,
    presence: true
end
