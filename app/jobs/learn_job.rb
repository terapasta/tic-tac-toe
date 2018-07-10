class LearnJob < ApplicationJob
  queue_as :default

  rescue_from GRPC::BadStatus, with: :handle_error

  def perform(bot_id)
    @bot = Bot.find(bot_id)
    @bot.update(learning_status: :processing)
    summarizer = Learning::Summarizer.new(@bot)
    summarizer.summary

    # NOTE:
    # 単語の normalize処理は python側にまとめる
    # https://www.pivotaltracker.com/n/projects/1879711/stories/158060539

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
