class IpAddress < ActiveRecord::Base
  belongs_to :bot

  validates :permission, presence: true
end
