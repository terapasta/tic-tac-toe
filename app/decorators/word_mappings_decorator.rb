class WordMappingsDecorator < Draper::CollectionDecorator
  def replace_synonym(text)
    result = text.dup
    mappings_hash.each do |synonym, word|
      if text.include?(synonym)
        result = text.gsub(/#{synonym}/, word)
      end
    end
    result
  end

  private
    def mappings_hash
      @mappings_hash ||= object.inject({}) { |memo, obj|
        { obj.synonym => obj.word }
      }
    end
end
