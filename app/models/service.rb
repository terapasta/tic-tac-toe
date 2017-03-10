class Service < ActiveRecord::Base
  belongs_to :bot
  enum feature: { contact: 1, helpdesk: 2, chitchat: 3, suggest_question: 4 }
end
