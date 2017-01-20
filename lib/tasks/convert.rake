namespace :convert do
  desc 'convert training_messages to question_answer'
  task :training_messages_to_question_answer, ['bot_id'] => :environment do |task, args|
    bot_id = args[:bot_id]
    convert(bot_id)
  end

  def convert(bot_id)
    bot = Bot.find(bot_id)
    qa = {}
    bot.trainings.find_each do |training|
      guest_body, bot_body = ''
      training.training_messages.where(learn_enabled: true).each do |training_message|
        if training_message.guest?
          guest_body = training_message.body
        elsif training_message.bot?
          if guest_body.present? && training_message.answer.present?
            qa[guest_body] = {
              answer_id: training_message.answer_id,
              body: training_message.body,
            }
            guest_body = ''
          end
        end
      end
    end
    bulk_insert(qa, bot)
  end

  def bulk_insert(qa_hash, bot)
    question_answers = qa_hash.map do |key, value|
      QuestionAnswer.new(
        bot_id: bot.id,
        question: key,
        answer_id: value[:answer_id],
      )
    end
    QuestionAnswer.import!(question_answers)
  end
end
