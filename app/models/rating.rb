class Rating < ActiveRecord::Base
  enum level: [:nothing, :good, :bad]
end
