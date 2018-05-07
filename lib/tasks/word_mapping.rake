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

  desc 'システム辞書をcsvエクスポート'
  task csv_export_system: :environment do
    csv = CSV.generate(force_quotes: false, row_sep: "\r\n") { |c|
      c << %w(単語 同じ意味の単語)
      WordMapping.systems.includes(:word_mapping_synonyms).each do |wm|
        c << [
          wm.word,
          *wm.word_mapping_synonyms.map(&:value)
        ]
      end
    }
    encoded_csv = SjisSafeConverter
      .sjis_safe(csv)
      .encode('Shift_JIS', invalid: :replace, undef: :replace, replace: '?')
    File.open(Rails.root.join('tmp/システム辞書.csv'), 'w', encoding: 'Shift_JIS') do |f|
      f.write(encoded_csv)
    end
  end

  desc '全辞書データを分かち書きしておく'
  task wakati_all: :environment do
    begin
      ActiveRecord::Base.transaction do
        WordMapping.all.each do |wm|
          wm.word_wakati = Wakatifier.apply(wm.word)
          wm.save!(validate: false)
          wm.word_mapping_synonyms.each do |wms|
            wms.value_wakati = Wakatifier.apply(wms.value)
            wms.save!(validate: false)
          end
        end
      end
    rescue => e
      pp e.record.errors
    end
  end

  task import_csv: :environment do
    wms = CSV.parse(Rails.root.join('tmp/wms.csv').read)
    wmss = CSV.parse(Rails.root.join('tmp/wmss.csv').read)

    begin
      ActiveRecord::Base.transaction do
        WordMapping.create!(wms.map{ |wm|
          {
            id: wm[0],
            word: wm[1],
            bot_id: wm[5],
          }
        })
        WordMappingSynonym.create!(wmss.select{ |wms| wms[5].present? }.map{ |wms|
          {
            id: wms[0],
            value: wms[1],
            word_mapping_id: wms[5],
          }
        })
      end
    rescue => e
      pp e.record
      pp e.record.errors
    end
  end
end
