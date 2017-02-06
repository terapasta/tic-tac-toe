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
end
