class Learning::Amplifier

  def initialize(bot)
    @bot = bot
  end

  def amp(sentence)
    @word_mappings ||= WordMapping.for_bot(@bot)
    @word_mappings.map { |wm|
      wm.word_mapping_synonyms.map { |s|
        sentence.gsub(wm.word, s.value) if sentence.include?(wm.word)
      }
    }.flatten.compact
  end
end
