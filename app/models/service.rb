class Service < ActiveRecord::Base
  enum feature: { contact: 1 }
end
