namespace :unify_question_answers do
  desc 'question_answersとqnswersをhas_oneリレーションにするためにレコードを増やす'
  task increase_answers: :environment do
    ActiveRecord::Base.transaction do
      question_answers = QuestionAnswer.select(:id, :answer_id).all.to_a

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
          # 旧answerをメモして、同じ内容のanswerを作成
          old_answer = qa.answer
          answer = Answer.create!(qa.answer.attributes.except('id'))

          # アソシエーションを旧answerから引き継ぐ
          %w(
            answer_files
            decision_branches
            training_messages
            question_answers
          ).each do |resources|
            old_answer.send(resources).each do |resource|
              resource.update!(answer_id: answer.id)
            end
          end
          # 親選択肢も新しいanswerに紐付ける
          if old_answer.parent_decision_branch.present?
            old_answer&.parent_decision_branch.update!(next_answer_id: answer.id)
          end
        end
      end
    end
  end
end
