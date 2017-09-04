class LearnJob < ActiveJob::Base
  queue_as :default

  def perform(bot_id)
    @bot = Bot.find(bot_id)
    @bot.update(learning_status: :processing)
    summarizer = Learning::Summarizer.new(@bot)
    summarizer.summary

    # Note: use_similarity_classificationがnilの場合もtrue扱いにする
    if @bot.use_similarity_classification?
      summarizer.unify_learning_training_message_words!
    else
      LearningTrainingMessage.amp!(@bot)
      LearningTrainingMessage.amp_by_sentence_synonyms!(@bot)
    end

    scores = Ml::Engine.new(@bot).learn
    unless @bot.use_similarity_classification?
      @bot.build_score if @bot.score.nil?
      @bot.score.update!(scores)
    end
    @bot.update!(learning_status: :successed)
  end

  private
    def handle_error(exception)
      Rails.logger.error('LearnJob: 学習の実行に失敗しました。')
      Rails.logger.error exception.message
      Rails.logger.error exception.backtrace.join("\n")
      @bot.update(learning_status: :failed)
      raise exception
    end
end
