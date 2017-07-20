class AllowedIpAddress < ActiveRecord::Base
  require 'resolv'

  belongs_to :bot

  IP_ADDRESS_VALIDATE = Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex)
  validates :value, presence: true, format: { with: IP_ADDRESS_VALIDATE }
end
