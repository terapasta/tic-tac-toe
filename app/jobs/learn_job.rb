class LearnJob < ActiveJob::Base
  queue_as :default

  # TODO job内で例外が発生するとログに表示されないのでデバッグしづらい
  def perform(bot_id)
    bot = Bot.find(bot_id)
    if Learning::Summarizer.new(bot).summary
      binding.pry
      LearningTrainingMessage.amp!(bot)
      LearningTrainingMessage.amp_by_sentence_synonyms!(bot)
      scores = Ml::Engine.new(bot).learn
      bot.score ||= bot.build_score
      bot.score.update!(scores)
      bot.update learning_status: :successed, learning_status_changed_at: Time.current
    else
      Rails.logger.debug('LearnJob: 学習の実行に失敗しました。')
      bot.update learning_status: :failed, learning_status_changed_at: Time.current
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    bot.update learning_status: :failed, learning_status_changed_at: Time.current
  end
end
