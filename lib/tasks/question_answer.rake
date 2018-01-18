namespace :question_answer do
  task convert_sjis_safe_dryrun: :environment do
    SjisSafeConverter.convert_all_question_answers(is_dryrun: true)
    SjisSafeConverter.convert_all_answers(is_dryrun: true)
    SjisSafeConverter.convert_all_decision_branches(is_dryrun: true)
  end

  task convert_sjis_safe: :environment do
    SjisSafeConverter.convert_all_question_answers(is_dryrun: false)
    SjisSafeConverter.convert_all_answers(is_dryrun: false)
    SjisSafeConverter.convert_all_decision_branches(is_dryrun: false)
  end

  task cleanup_duplicated_septeni_data: :environment do
    group_by_dup = -> (data, attr_name) {
      data.inject({}) { |res, datum|
        res[datum.send(attr_name)] ||= []
        res[datum.send(attr_name)] << datum
        res
      }.select{ |k, data| data.count > 1 }
    }

    begin
      ActiveRecord::Base.transaction do
        group_by_dup.(QuestionAnswer.where(bot_id: 9), :question).each do |q, qas|
          group_by_dup.(qas, :answer_id).each do |aid, qas|
            qas.map(&:destroy!)
          end
        end
      end
    rescue => e
      puts e.message
    end
  end

  desc '大量のツリーデータのインポートに使う　カラム：topic_tags,question,answer,decision_branch.body,decision_branch.answer,...　ヘッダーなし'
  task import_tree: :environment do
    fail 'BOT_ID is required' if ENV['BOT_ID'].blank?
    bot = Bot.find(ENV['BOT_ID'])
    reader = FileReader.new(file_path: Rails.root.join('tmp/tree.csv'), encoding: Encoding::Shift_JIS)
    all_data = {}

    CSV.new(reader.read).each do |raw_row|
      row = raw_row.compact
      tags = row[0].gsub('／', '/').split('/')
      qa = row.slice(1, 2)
      dbs = row.slice(3, 100).each_slice(2).to_a
      all_data[qa] ||= {}
      all_data[qa][:tags] ||= []
      all_data[qa][:tags] += tags
      all_data[qa][:tags].uniq!
      all_data[qa][:dbs] ||= []
      all_data[qa][:dbs] << dbs
    end

    ActiveRecord::Base.transaction do
      all_data.to_a.each do |data|
        qa_data = data.first
        tags_data = data.second[:tags]
        dbs_data = data.second[:dbs]

        qa = bot.question_answers.find_or_create_by!(
          question: qa_data.first,
          answer: qa_data.second
        )

        tags = tags_data.map{ |t| bot.topic_tags.find_or_create_by!(name: t) }
        new_tags = tags - qa.topic_tags
        qa.topic_taggings.create(new_tags.map{ |t| { topic_tag_id: t.id } })

        dbs_data.each do |dbs|
          parent_db = nil
          dbs.each do |db|
            if parent_db.nil?
              parent_db = qa.decision_branches.find_or_create_by!(
                bot_id: bot.id,
                body: db.first,
                answer: db.second
              )
            else
              parent_db = parent_db.child_decision_branches.find_or_create_by!(
                bot_id: bot.id,
                body: db.first,
                answer: db.second
              )
            end
          end
        end
      end
    end
  end
end
