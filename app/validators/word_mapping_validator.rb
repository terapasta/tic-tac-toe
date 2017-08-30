class WordMappingValidator < ActiveModel::Validator
  def validate(record)
    record.word_mapping_synonyms.each do |wms|
      if wms.value == record.word
        record.errors.add :base, '単語と同義語を同じにはできません'
      end
    end

    values = record.word_mapping_synonyms.map(&:value)
    unless values.size == values.uniq.size
      record.errors.add :base, '同じ同意語は登録できません'
    end

    # values = WordMappingSynonym.where(word_mapping_id: WordMapping.select(:id).where(bot_id: record.bot_id)).pluck(:value)
    binding.pry
    values = WordMappingSynonym.registered_synonym(record.bot_id)
    
    if values.any? { |v| v == record.word }
      record.errors.add :base, 'この単語は既に同義語に登録されています'
    end

    record.word.strip!
  end
end
