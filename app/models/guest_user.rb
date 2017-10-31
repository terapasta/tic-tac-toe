class GuestUser < ApplicationRecord
  validates :name,
    presence: true

  validates :email,
    email: true,
    allow_blank: true

  validates :guest_key,
    presence: true
end
