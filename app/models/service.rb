class Service < ActiveRecord::Base
  enum feature: { contact: 1, helpdesk: 2, chitchat: 3 }
end
