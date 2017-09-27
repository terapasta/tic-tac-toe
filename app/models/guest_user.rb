class GuestUser < ActiveRecord::Base
  validates :name,
    presence: true

  validates :guest_key,
    presence: true
end
