class DataSummary < ApplicationRecord
  belongs_to :bot
  validates :type_name, presence: true
end
