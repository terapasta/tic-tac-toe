module SynonymReplacer
  def self.replace(text, synonym, word)
    return text unless text.include?(synonym)

    # 質問文、シノニム、置き換える単語を全て分かち書きする（スペース区切りの文字列）
    text = to_wakati(text)
    synonym = to_wakati(synonym)
    word = to_wakati(word)

    result = ''
    start_text_index = 0

    loop do
      cropped_text = text[start_text_index, text.length]
      break if cropped_text.nil?

      # もし先頭にスペースが挿入されていなければ挿入する
      is_added_head_space = false
      if cropped_text[0] != ' '
        cropped_text = " #{cropped_text}"
        is_added_head_space = true
      end

      # 置き換え対象の単語を探す
      word_start = cropped_text.index(word) || -1
      word_end = word_start + word.length - 1

      # 置き換え後の単語を探す
      synonym_start = cropped_text.index(synonym) || -1
      synonym_end = synonym_start + synonym.length - 1

      # 走査した文字の末端
      next_text_index = synonym_end + (is_added_head_space ? 0 : 1)

      # 走査した対象
      target_range = text[start_text_index, next_text_index]

      break if target_range.nil?

      if target_range[0] != ' '
        target_range = " #{target_range}"
      end

      # 文章の中に置き換え語の単語が含まれていなければ無条件に置換
      if synonym_start == -1
        result += text[start_text_index, text.length]
        break
      end

      # 置き換え対象の語が見つかり、かつ
      # 置き換え対象の語と含まれているシノニムの位置がかぶっている場合は、
      # 何もしない
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
    res = Natto::MeCab.new('-Owakati').parse(original.to_s).sub(/\n$/, '')
    res = " #{res}" unless res.starts_with?(' ')
    res
  end
end