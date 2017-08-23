namespace :word_mapping do
  desc '同義語テーブルを1対多のアソシエーションに変更する'
  task data_migration: :environment do
    begin
      ActiveRecord::Base.transaction do
        memo_ids = {}
        delete_ids = []
        WordMapping.pluck(:id, :word, :synonym).each do |wm|
          id = wm[0]
          word = wm[1]
          synonym = wm[2]
          if memo_ids[word].present?
            delete_ids << id
          else
            memo_ids[word] ||= id
          end
          WordMappingSynonym.create!(value: synonym, word_mapping_id: memo_ids[word])
        end
        WordMapping.where(id: delete_ids).delete_all
        puts 'Success'
      end
    rescue => e
      puts e.inspect
      puts e.backtrace
    end
  end
end
