namespace :rating do
  desc 'messages.ratingからratingモデルを作成する'
  task data_migration: :environment do
    begin
      ActiveRecord::Base.transaction do
        Rating.destroy_all
        Message.where.not(rating: 0).where.not(question_answer_id: nil).find_each do |message|
          pair = Message.find_pair_message_from(message)
          next if pair.nil?
          Rating.create!(
            level: message.rating,
            message_id: message.id,
            question_answer_id: message.question_answer_id,
            bot_id: message.chat.bot_id,
            question: pair.body,
            answer: message.body,
          )
        end
      end
    rescue => e
      puts e.inspect
      puts e.backtrace
    end
  end
end
