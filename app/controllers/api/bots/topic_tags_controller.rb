class Api::Bots::TopicTagsController < Api::BaseController
  before_action :set_bot

  def index
    authorize TopicTag
    @topic_tags = policy_scope(@bot.topic_tags).all
    render json: @topic_tags, adapter: :json
  end

  def create
    @topic_tag = @bot.topic_tags.build(permitted_attributes(TopicTag))
    authorize @topic_tag
    if @topic_tag.save
      render json: @topic_tag, adapter: :json, status: :created
    else
      render json: { errors: @topic_tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end
end
