class LearnJob < ActiveJob::Base
  queue_as :default

  def perform(bot_id)
    bot = Bot.find(bot_id)
    Learning::Summarizer.new(bot).summary
    LearningTrainingMessage.amp!(bot)
    LearningTrainingMessage.amp_by_sentence_synonyms!(bot)
    scores = Ml::Engine.new(bot).learn
    bot.score ||= bot.build_score
    bot.score.update!(scores)
    bot.update learning_status: :successed, learning_status_changed_at: Time.current
  rescue => e
    Rails.logger.debug('LearnJob: 学習の実行に失敗しました。')
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    bot.update learning_status: :failed, learning_status_changed_at: Time.current
    raise e
  end
end
