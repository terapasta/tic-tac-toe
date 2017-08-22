class WordMappingSynonym < ActiveRecord::Base
  belongs_to :word_mapping
  
  validates :value,
    presence: true,
    length: { maximum: 20 }
end
