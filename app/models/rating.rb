class Rating < ActiveRecord::Base
  # Note: nothingは実質未利用(nothing時はratingレコードがない)
  enum level: [:nothing, :good, :bad]
end
