class LearnJob < ActiveJob::Base
  queue_as :default

  rescue_from StandardError, with: :handle_error

  before_enqueue do |job|
    # NOTE: 同じbotの未実行学習ジョブがあったら削除する
    bot_id = job.arguments[0] # performメソッドの第一引数
    Delayed::Job
        .where(attempts: 0, locked_at: nil)
        .where.not(id: job.job_id)
        .each do |delayed_job|
      job_data = YAML.load(delayed_job.handler).job_data
      if job_data['job_class'] == self.class.name and job_data['arguments'][0] == bot_id
        # TODO: 削除してしまうと思わぬ挙動をする恐れがないだろうか
        delayed_job.delete
      end
    end
  end

  def perform(bot_id)
    @bot = Bot.find(bot_id)
    @bot.update(learning_status: :processing)
    summarizer = Learning::Summarizer.new(@bot)
    summarizer.summary

    if @bot.learning_parameter&.use_similarity_classification? != false
      summarizer.unify_learning_training_message_words!
    else
      LearningTrainingMessage.amp!(@bot)
      LearningTrainingMessage.amp_by_sentence_synonyms!(@bot)
    end

    scores = Ml::Engine.new(@bot).learn
    @bot.build_score if @bot.score.nil?
    @bot.score.update!(scores)
    @bot.update!(learning_status: :successed)
  end

  private
    def handle_error
      Rails.logger.error('LearnJob: 学習の実行に失敗しました。')
      Rails.logger.error exception.message
      Rails.logger.error exception.backtrace.join("\n")
      @bot.update(learning_status: :failed)
      raise exception
    end
end
