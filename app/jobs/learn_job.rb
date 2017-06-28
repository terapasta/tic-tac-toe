class LearnJob < ActiveJob::Base
  queue_as :default

  def perform(bot_id)
    bot = Bot.find(bot_id)
    summarizer = Learning::Summarizer.new(bot)
    summarizer.summary

    LearningTrainingMessage.amp!(bot)
    LearningTrainingMessage.amp_by_sentence_synonyms!(bot)

    scores = Ml::Engine.new(bot).learn
    bot.build_score if bot.score.nil?
    bot.score.update!(scores)
    bot.update!(learning_status: :successed)
  rescue => e
    Rails.logger.debug('LearnJob: 学習の実行に失敗しました。')
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    bot.update(learning_status: :failed)
    raise e
  end
end
