class ContactState < ActiveRecord::Base
  belongs_to :chat
  validates :name, presence: true
end
