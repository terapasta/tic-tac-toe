class IpAddress < ActiveRecord::Base
  belongs_to :bot

  validates :ip_address, presence: true
end
