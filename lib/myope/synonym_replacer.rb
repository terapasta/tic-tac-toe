module SynonymReplacer
  def self.replace(text, synonym, word)
    return text unless text.include?(synonym)

    text = to_wakati(text)
    synonym = to_wakati(synonym)
    word = to_wakati(word)

    result = ''
    start_text_index = 0

    loop do
      cropped_text = text[start_text_index, text.length]
      break if cropped_text.nil?
      is_added_head_space = false
      if cropped_text[0] != ' '
        cropped_text = " #{cropped_text}"
        is_added_head_space = true
      end
      word_start = cropped_text.index(word) || -1
      word_end = word_start + word.length - 1
      synonym_start = cropped_text.index(synonym) || -1
      synonym_end = synonym_start + synonym.length - 1
      next_text_index = synonym_end + (is_added_head_space ? 0 : 1)
      target_range = text[start_text_index, next_text_index]
      break if target_range.nil?
      if target_range[0] != ' '
        target_range = " #{target_range}"
      end

      if synonym_start == -1
        result += text[start_text_index, text.length]
        break
      end

      if word_start != -1 &&
        (word_start..word_end).overlaps?(synonym_start..(synonym_end - 1))
        result += target_range.sub(/^\s/, '')
      else
        result += target_range.sub(synonym, word).sub(/^\s/, '')
      end

      start_text_index = next_text_index + start_text_index
    end

    result
  end

  def self.to_wakati(original)
    if mecab_exists?
      " #{ `echo #{original} | mecab -Owakati`.sub(/\n/, '') }"
    else
      original
    end
  end

  def self.mecab_exists?
    `type -a mecab`.present?
  end
end