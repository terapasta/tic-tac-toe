class Api::Bots::TopicTagsController < Api::BaseController
  before_action :set_bot

  def index
    authorize TopicTag
    if params[:data_format] == 'repo'
      render json: { topicTagsRepo: DeepCamelizeKeys.deep_camelize_keys(@bot.topic_tags.decorate.as_repo_json) }
    else
      render json: @bot.topic_tags, adapter: :json
    end
  end

  def create
    @topic_tag = @bot.topic_tags.find_or_initialize_by(permitted_attributes(TopicTag))
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
