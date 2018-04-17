namespace :circleci do
  desc 'CricleCIでpython benchmarkを動かすためのseedデータ作成'
  task python_benchmark_seed: :environment do
    ActiveRecord::Base.transaction do
      Bot.create!(is_demo: false).tap do |bot|
        bot.create_learning_parameter!(LearningParameter.default_attributes)
        bot.question_answers.create!(question: 'example q', answer: 'example a').tap do |qa|
          bot.chats.create!(guest_key: SecureRandom.uuid).tap do |chat|
            chat.messages.create!(speaker: :bot, question_answer: qa).tap do |message|
              message.create_rating!(level: :good, bot_id: bot.id, question: 'example q', answer: 'example a')
            end
          end
        end
      end
    end
  end
end