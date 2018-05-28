namespace :bot do
  task learn_all: :environment do
    Bot.pluck(:id).each do |bot_id|
      LearnJob.perform_later(bot_id)
      pp "Enqueued learn job for #{bot_id}"
    end
  end
end