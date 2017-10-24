class AllowedHost < ApplicationRecord
  validates :domain, presence: true
  belongs_to :bot, required: true
  enum scheme: ['http://', 'https://']

  def to_origin
    "#{scheme}#{domain}"
  end
end
