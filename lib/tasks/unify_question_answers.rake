namespace :unify_question_answers do
  def recursive_duplicate_answer!(answer)
    # 旧answerをメモして、同じ内容のanswerを作成
    old_answer = answer
    answer = Answer.create!(answer.attributes.except('id'))

    # AnswerFileを複製する
    old_answer.answer_files.each do |answer_file|
      AnswerFile.create!(answer_id: answer.id, remote_file_url: answer_file.file_url)
    end

    # DecisionBranchをそれぞれ複製する
    old_answer.decision_branches.each do |decision_branch|
      copy_decision_branch = decision_branch.dup
      copy_decision_branch.answer_id = answer.id
      copy_decision_branch.save!

      # next_answerを複製する
      if copy_decision_branch.next_answer.present?
        # ツリー構造なので再帰して複製
        copy_decision_branch.next_answer_id = recursive_duplicate_answer!(copy_decision_branch.next_answer)
        copy_decision_branch.save!
      end
    end

    # 親QuestionAnswerかDecisionBranchのanswer_idを更新するために返す
    answer.id
  end

  desc 'question_answersとqnswersをhas_oneリレーションにするためにレコードを増やす'
  task increase_answers: :environment do
    ActiveRecord::Base.transaction do
      question_answers = QuestionAnswer.all.to_a

      # このような形にする
      # {2=>
      #  [#<QuestionAnswer:0x007f7f74c3aa28 id: 1, answer_id: 2>,
      #   #<QuestionAnswer:0x007f7f74c3a6e0 id: 5, answer_id: 2>,
      #   #<QuestionAnswer:0x007f7f74c3a488 id: 6, answer_id: 2>],
      # 3=>
      #  [#<QuestionAnswer:0x007f7f74c3a348 id: 2, answer_id: 3>,
      #   #<QuestionAnswer:0x007f7f74c3a1e0 id: 31, answer_id: 3>]}
      duplicated_question_answers = question_answers.select{ |qa|
        question_answers.detect{ |_qa|
          _qa.id != qa.id && _qa.answer_id == qa.answer_id
        }.present?
      }.inject({}) { |acc, qa|
        acc[qa.answer_id] ||= []
        acc[qa.answer_id].push(qa)
        acc
      }

      duplicated_question_answers.each do |answer_id, qas|
        # 最初のqaは無視
        qas.drop(1).each do |qa|
          next if qa.answer.blank?
          qa.answer_id = recursive_duplicate_answer!(qa.answer)
          qa.save!
        end
      end
    end
  end

  def recursive_hoge(answer_data)
    answer_data.decision_branches.each do |decision_branch|
      if decision_branch.next_answer.present?
        decision_branch.answer = decision_branch.next_answer.body
        recursive_hoge(decision_branch.next_answer)
      end
    end
  end

  desc 'answerテーブルをquestion_answersに統合する'
  task merge_answers: :environment do
    ActiveRecord::Base.transaction do
      QuestionAnswer.find_each do |question_answer|
        next if question_answer.answer_data.blank?

        question_answer.answer = question_answer.answer_data.body
        question_answer.answer_data.answer_files.each do |answer_file|
          answer_file.question_answer_id = question_answer.id
          answer_file.save!
        end
        question_answer.save!
      end
    end
  end
end
