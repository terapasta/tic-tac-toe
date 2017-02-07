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
end
