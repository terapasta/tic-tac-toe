namespace :sentence_synonyms do
  desc 'seq2seq用の同義文データ(input, output)をファイルとして取り出す'
  task extract: :environment do
    f_in = File.open('input.txt', 'w')
    f_out = File.open('output.txt', 'w')

    in_arr = []
    out_arr = []

    training_message_ids = SentenceSynonym.pluck(:training_message_id).uniq
    training_message_ids.each do |training_message_id|
      arr = SentenceSynonym.where(training_message_id: training_message_id).pluck(:body)
      arr.each_with_index do |body, idx|
        if idx.even?
          in_arr << separate(body)
          if idx + 1 == arr.count
            out_arr << separate(arr.first)
          end
        elsif idx.odd?
          out_arr << separate(body)
        end
      end
    end

    arr = in_arr.zip(out_arr).shuffle
    arr.each do |row|
      f_in.puts(row[0])
      f_out.puts(row[1])
    end
  end

  def separate(text)
    # HACK カスタム辞書使いたい
    natto = Natto::MeCab.new
    natto.enum_parse(text).map(&:surface).join(' ')
  end
end
