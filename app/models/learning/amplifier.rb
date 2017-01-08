class Learning::Amplifier

  def initialize(user)
    @user = user
  end

  def amp(sentence)
    @word_mappings ||= WordMapping.for_user(@user)
    @word_mappings.map do |word_mapping|
      [
         sentence.include?(word_mapping.word) ? sentence.gsub(/#{word_mapping.word}/, word_mapping.synonym) : nil,
         sentence.include?(word_mapping.synonym) ? sentence.gsub(/#{word_mapping.synonym}/, word_mapping.word) : nil
      ]
    end.flatten.compact
  end
end
