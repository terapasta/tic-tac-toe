class WordMappingsDecorator < Draper::CollectionDecorator
  def initialize(object, options = {})
    wms = object.includes(:word_mapping_synonyms).to_a
    # NOTE ユーザーが設定した辞書が後勝ちするように並べ替える
    system_wms = wms.select{ |it| it.bot_id.blank? }
    bot_wms = wms.select{ |it| it.bot_id.present? }
    wms = system_wms + bot_wms
    super(wms, options)
  end

  def replace_synonym(text)
    result = text.dup
    mappings.each do |mapping|
      word = mapping.first
      mapping.second.each do |synonym|
        result = SynonymReplacer.replace(result, synonym, word)
      end
    end
    result
  end

  private
    def mappings
      @mappings ||= object.inject([]) { |memo, word_mapping|
        synonyms = word_mapping.word_mapping_synonyms.map(&:value)
        synonyms.each do |synonym|
          memo.select!{ |it| it.second.exclude?(synonym) }
          index = memo.index{ |it| it.first == word_mapping.word }
          if index.blank?
            memo << [word_mapping.word, [synonym]]
          else
            memo[index][1] ||= []
            memo[index][1] << synonym
          end
        end
        memo
      }
    end
end
