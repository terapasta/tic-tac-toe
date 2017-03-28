class TopicTagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  before_action :set_topic_tag, only: [:show, :edit, :update, :destroy]

  # GET /topic_tags
  # GET /topic_tags.json
  def index
    @topic_tags = TopicTag.where(bot_id = @bot.id)
  end

  # GET /topic_tags/1
  # GET /topic_tags/1.json
  def show
  end

  # GET /topic_tags/new
  def new
    @topic_tag = @bot.topic_tags.build
  end

  # GET /topic_tags/1/edit
  def edit
  end

  # POST /topic_tags
  # POST /topic_tags.json
  def create
    respond_to do |format|
      @topic_tag = TopicTag.new(topic_tag_params)
      @topic_tag.bot_id = @bot.id
      if @topic_tag.save
        format.html { redirect_to bot_topic_tags_path(@bot), notice: '登録しました。' }
        format.json { render :show, status: :created, location: @topic_tag }
      else
        format.html do
          flash.now.alert = '登録できませんでした。'
          render :new
        end
        format.json { render json: @topic_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topic_tags/1
  # PATCH/PUT /topic_tags/1.json
  def update
    respond_to do |format|
      if @topic_tag.update(topic_tag_params)
        format.html { redirect_to bot_topic_tags_path(@bot), notice: '更新しました。' }
        format.json { render :show, status: :ok, location: @topic_tag }
      else
        format.html do
          flash.now.alert = '更新できませんでした。'
          render :edit
        end
        format.json { render json: @topic_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_tags/1
  # DELETE /topic_tags/1.json
  def destroy
    @topic_tag.destroy
    respond_to do |format|
      format.html { redirect_to bot_topic_tags_path(@bot), notice: '削除しました。' }
      format.json { head :no_content }
    end
  end

  private

    def set_bot
      @bot = Bot.find_by(params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_topic_tag
      @topic_tag = TopicTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_tag_params
      params.require(:topic_tag).permit(:name)
    end
end
