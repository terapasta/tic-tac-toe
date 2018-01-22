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
    mappings.each do |mapping|
      word = mapping.first
      mapping.second.each do |synonym|
        if text.include?(synonym)
          result = text.gsub(/#{synonym}/, word)
        end
      end
    end
    result
  end

  private
    def mappings
      @mappings ||= object.inject([]) { |memo, word_mapping|
        word_mapping.word_mapping_synonyms.each do |synonym|
          index = memo.index{ |it| it.first == word_mapping.word }
          if index.blank?
            memo << [word_mapping.word, [synonym.value]]
          else
            memo[index][1] ||= []
            memo[index][1] << synonym.value
          end
        end
        memo
      }
    end
end
