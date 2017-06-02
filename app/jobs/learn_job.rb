class LearnJob < ActiveJob::Base
  queue_as :default

  def perform(bot_id)
    bot = Bot.find(bot_id)
    summarizer = Learning::Summarizer.new(bot)
    summarizer.summary

    if bot.learning_parameter&.use_similarity_classification?
      summarizer.unify_learning_training_message_words!
    else
      LearningTrainingMessage.amp!(bot)
      LearningTrainingMessage.amp_by_sentence_synonyms!(bot)
    end

    scores = Ml::Engine.new(bot).learn
    bot.score ||= bot.build_score
    bot.score.update!(scores)
    bot.update learning_status: :successed
  rescue => e
    Rails.logger.debug('LearnJob: 学習の実行に失敗しました。')
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    bot.update learning_status: :failed

    raise e
  end
end
