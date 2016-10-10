namespace :debug do
  BODY = 'debug:create_learning_training_messages'

  desc '10万件のmessageを投入する'
  task create_learning_training_messages: :environment do
    learning_training_messages = 20_000.times.map do |i|
      puts "#{i}件の処理中" if i % 1000 == 0
      LearningTrainingMessage.new(bot_id: 1, question: BODY, answer_body: 'hoge', answer_id: 1)
    end
    puts 'Bulk Insertを実行(10分程度かかります)'
    LearningTrainingMessage.import(learning_training_messages)
  end

  desc '投入したmessageを削除する'
  task delete_learning_training_messages: :environment do
    LearningTrainingMessage.where(question: BODY).delete_all
  end
end
