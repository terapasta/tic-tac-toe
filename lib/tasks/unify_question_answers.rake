namespace :unify_question_answers do
  desc 'question_answersとqnswersをhas_oneリレーションにするためにレコードを増やす'
  task increase_answers: :environment do
    ActiveRecord::Base.transaction do
      QuestionAnswer.find_each do |qa|
        puts qa.answer.dup.inspect
        # TODO: 保存する
        # qa.answer.dup.save
      end
    end
  end
end
