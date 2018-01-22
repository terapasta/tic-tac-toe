class WordMappingsDecorator < Draper::CollectionDecorator
  def initialize(object, options = {})
    wms = object.includes(:word_mapping_synonyms).to_a.tap do |wms|
      # NOTE ユーザーが設定した辞書が後勝ちするように並べ替える
      system_wms = wms.select{ |it| it.bot_id.blank? }
      bot_wms = wms.select{ |it| it.bot_id.present? }
      wms = system_wms + bot_wms
    end
    super(wms, options)
  end

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
