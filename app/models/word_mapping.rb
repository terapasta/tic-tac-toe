class WordMapping < ActiveRecord::Base
  validates :word, presence: true, length: { maximum: 20 }
  validates :synonym, presence: true, length: { maximum: 20 }

  validate :unique_pair

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

  private

    def unique_pair
      if WordMapping.exists?(user_id: user_id, word: word, synonym: synonym)
        errors.add :base, '単語と同意語の組み合わせは既に存在しています。'
      end
    end
end
