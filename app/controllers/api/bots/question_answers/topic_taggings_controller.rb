class Api::Bots::QuestionAnswers::TopicTaggingsController < Api::BaseController
  before_action :set_bot
  before_action :set_question_answer

  def index
    authorize TopicTagging
    @topic_taggings = @question_answer.topic_taggings
    render json: @topic_taggings, adapter: :json
  end

  def create
    @topic_tagging = @question_answer.topic_taggings.build(permitted_attributes(TopicTagging))
    authorize @topic_tagging
    if @topic_tagging.save
      render json: @topic_tagging, adapter: :json, status: :created
    else
      render json: { errors: @topic_tagging.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @topic_tagging = @question_answer.topic_taggings.find(params[:id])
    if @topic_tagging.destroy
      render json: {}, status: :no_content
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find(params[:question_answer_id])
      authorize @question_answer
    end
end
