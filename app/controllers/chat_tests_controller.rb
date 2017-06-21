class ChatTestsController < ApplicationController
  before_action :set_bot
  before_action :set_chat, only: [:create, :show]

  def new
  end

  def create
    # インポートデータからchatを作成する
    # redirect_to bot_chat_test_path(@bot, @chat)
  end

  def show
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end

    def set_chat
      @chat = Chat.find(params[:chat_id])
    end
end
