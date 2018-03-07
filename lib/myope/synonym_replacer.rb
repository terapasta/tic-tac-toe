module SynonymReplacer
  def self.replace(text, synonym, word)
    return text unless text.include?(synonym)

    result = ''
    start_text_index = 0

    loop do
      cropped_text = text[start_text_index, text.length]
      word_start = cropped_text.index(word) || -1
      word_end = word_start + word.length - 1
      synonym_start = cropped_text.index(synonym) || -1
      synonym_end = synonym_start + synonym.length - 1
      next_text_index = synonym_end + 1
      target_range = text[start_text_index, next_text_index]

      if synonym_start == -1
        result += text[start_text_index, text.length]
        p result
        break
      end

      synonym_is_overlap_word = word_start != -1 &&
        (word_start..word_end).overlaps?(synonym_start..synonym_end)
      if synonym_is_overlap_word
        result += target_range
      else
        result += target_range.sub(synonym, word)
      end

      start_text_index = next_text_index + start_text_index
    end

    result
  end
end