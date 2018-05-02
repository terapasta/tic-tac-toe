class LearnJob < ApplicationJob
  queue_as :default

  rescue_from GRPC::BadStatus, with: :handle_error

  def perform(bot_id)
    @bot = Bot.find(bot_id)
    @bot.update(learning_status: :processing)

    scores = Ml::Engine.new(@bot).learn
    unless @bot.use_similarity_classification?
      @bot.build_score if @bot.score.nil?
      @bot.score.update!(scores)
    end
    @bot.update!(learning_status: :successed)
  end

  private
    def handle_error(e)
      Rails.logger.error ['LearnJob: 学習の実行に失敗しました。', e.message, *e.backtrace].join("\n")
      @bot.update(learning_status: :failed)
      raise e
    end
end
