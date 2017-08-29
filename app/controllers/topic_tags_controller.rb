class TopicTagsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def update
    if @bot.update(permitted_attributes(@bot))
      redirect_to bot_topic_tags_path(@bot), notice: '更新しました。'
    else
      flash.now.alert = '更新できませんでした。'
      render :show
    end
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end
end
