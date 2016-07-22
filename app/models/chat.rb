class Chat < ActiveRecord::Base
  has_many :messages
  has_one :contact_state
  enum context: { normal: 'normal', contact: 'contact' }
end
