class WordMappingsDecorator < Draper::CollectionDecorator
  def replace_synonym(text)
    result = text.dup
    mappings_hash.each do |word, synonyms|
      synonyms.each do |synonym|
        if text.include?(synonym)
          result = text.gsub(/#{synonym}/, word)
        end
      end
    end
    result
  end

  private
    def mappings_hash
      @mappings_hash ||= object.inject({}) { |memo, word_mapping|
        word_mapping.word_mapping_synonyms.each do |synonym|
          memo[word_mapping.word] ||= []
          memo[word_mapping.word].push(synonym.value)
        end
        memo
      }
    end
end
