class ThreadsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @chats = @bot.chats
      .has_multiple_messages
      .not_staff(!current_user.staff?)
      .has_answer_failed(params[:filter])
      .has_good_answer(params[:good])
      .has_bad_answer(params[:bad])
      .page(params[:page])
  end

  private
    def set_bot
      @bot = bots.find_by!(id: params[:bot_id])
    end
end
