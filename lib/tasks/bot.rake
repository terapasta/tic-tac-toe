namespace :bot do
  task learn_all: :environment do
    Bot.all.each do |bot|
      LearnJob.perform_later(bot.id)
      bot.update(learning_status: :processing)
    end
  end
end