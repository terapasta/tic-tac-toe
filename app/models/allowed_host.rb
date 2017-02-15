class AllowedHost < ActiveRecord::Base
  validates :domain, presence: true
  belongs_to :bot, required: true
  enum scheme: ['http://', 'https://']
end
