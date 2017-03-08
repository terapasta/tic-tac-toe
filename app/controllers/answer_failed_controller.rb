class AnswerFailedController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_chat
  before_action :set_message

  def create
    if @message.save_to_answer_failed
      redirect_to bot_thread_messages_path(@bot, @chat, @message), notice: '回答失敗に変更しました。'
    else
      flash.now.alert = '回答失敗に変更できませんでした。'
      redirect_to bot_thread_messages_path(@bot, @chat, @message)
    end
  end

  def destroy
    if @message.save_to_answer_succeed
      redirect_to bot_thread_messages_path(@bot, @chat, @message), notice: '回答成功に変更しました。'
    else
      flash.now.alert = '回答成功に変更できませんでした。'
      redirect_to bot_thread_messages_path(@bot, @chat, @message)
    end
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def set_chat
      @chat = @bot.chats.find(params[:thread_id])
    end

    def set_message
      @message = @chat.messages.find(params[:message_id])
    end
end
