class WordMapping < ActiveRecord::Base
  validates :word, presence: true, length: { maximum: 20 }
  validates :synonym, presence: true, length: { maximum: 20 }
end
