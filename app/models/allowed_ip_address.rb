class AllowedIpAddress < ActiveRecord::Base
  belongs_to :bot

  require 'resolv'
  validates :value, presence: true, format: { with: Resolv::IPv4::Regex }
end
