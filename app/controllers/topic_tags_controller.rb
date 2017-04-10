class TopicTagsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  before_action :set_topic_tag, only: [:show, :edit, :update, :destroy]

  def index
    @topic_tags = @bot.topic_tags
  end

  def new
    @topic_tag = @bot.topic_tags.build
  end

  def edit
  end

  def create
    @topic_tag = TopicTag.new(topic_tag_params)
    @topic_tag.bot_id = @bot.id
    if @topic_tag.save
      redirect_to bot_topic_tags_path(@bot), notice: '登録しました。'
    else
      flash.now.alert = '登録できませんでした。'
      render :new
    end
  end

  def update
    if @topic_tag.update(topic_tag_params)
      redirect_to bot_topic_tags_path(@bot), notice: '更新しました。'
    else
      flash.now.alert = '更新できませんでした。'
      render :edit
    end
  end

  def destroy
    @topic_tag.destroy
    redirect_to bot_topic_tags_path(@bot), notice: '削除しました。'
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_topic_tag
      @topic_tag = TopicTag.find(params[:id])
    end

    def topic_tag_params
      params.require(:topic_tag).permit(:name)
    end
end
