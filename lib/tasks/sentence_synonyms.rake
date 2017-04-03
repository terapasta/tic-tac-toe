namespace :sentence_synonyms do
  desc 'seq2seq用の同義文データ(input, output)をファイルとして取り出す'
  task extract: :environment do
    f_in = File.open('input.txt', 'w')
    f_out = File.open('output.txt', 'w')

    training_message_ids = SentenceSynonym.pluck(:training_message_id).uniq
    training_message_ids.each do |training_message_id|
      arr = SentenceSynonym.where(training_message_id: training_message_id).pluck(:body)
      arr.each_with_index do |body, idx|
        if idx.even?
          f_in.puts(body)
          if idx + 1 == arr.count
            f_out.puts(arr.first)
          end
        elsif idx.odd?
          f_out.puts(body)
        end
      end
    end
  end
end
