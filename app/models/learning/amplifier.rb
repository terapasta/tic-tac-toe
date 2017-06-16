class Learning::Amplifier

  def initialize(bot)
    @bot = bot
  end

  def amp(sentence)
    @word_mappings ||= WordMapping.for_bot(@bot)
    @word_mappings.map do |word_mapping|
      [
         sentence.include?(word_mapping.word) ? sentence.gsub(/#{word_mapping.word}/, word_mapping.synonym) : nil,
         sentence.include?(word_mapping.synonym) ? sentence.gsub(/#{word_mapping.synonym}/, word_mapping.word) : nil
      ]
    end.flatten.compact
  end
end
