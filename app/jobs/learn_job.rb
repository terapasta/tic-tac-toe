class LearnJob < ActiveJob::Base
  queue_as :default

  def perform(bot_id)
    bot = Bot.find(bot_id)
    if Learning::Summarizer.new(bot).summary
      LearningTrainingMessage.amp!(bot)
      scores = Ml::Engine.new(bot).learn
      bot.score ||= bot.build_score
      bot.score.update!(scores)
    else
      Rails.logger.debug('LearnJob: 学習の実行に失敗しました。')
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
  end
end
