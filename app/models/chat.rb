class Chat < ActiveRecord::Base
  has_many :messages
  enum context: { contact: 'contact' }
end
