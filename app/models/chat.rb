class Chat < ActiveRecord::Base
  has_many :messages
  has_many :contact_states
  enum context: { normal: 'normal', contact: 'contact' }
end
