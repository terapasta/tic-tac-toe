class WordMapping < ActiveRecord::Base
  validates :word, presence: true, length: { maximum: 20 }
  validates :synonym, presence: true, length: { maximum: 20 }

  def self.variations_of(sentence)
    arr1 = all.map do |word_mapping|
      if sentence.include?(word_mapping.word)
        sentence.gsub(/#{word_mapping.word}/, word_mapping.synonym)
      end
    end.compact

    arr2 = all.map do |word_mapping|
      if sentence.include?(word_mapping.synonym)
        sentence.gsub(/#{word_mapping.synonym}/, word_mapping.word)
      end
    end.compact

    arr1 + arr2
  end
end
