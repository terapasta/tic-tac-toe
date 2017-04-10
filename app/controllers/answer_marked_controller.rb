class AnswerMarkedController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_chat
  before_action :set_message

  def create
    if @message.save_to_answer_marked
      redirect_to bot_thread_messages_path(@bot, @chat, @message), notice: '注意回答に変更しました。'
    else
      flash.now.alert = '注意回答に変更できませんでした。'
      redirect_to bot_thread_messages_path(@bot, @chat, @message)
    end
  end

  def destroy
    if @message.save_to_remove_answer_marked
      redirect_to bot_thread_messages_path(@bot, @chat, @message), notice: '注意回答を取り消しました。'
    else
      flash.now.alert = '注意回答の取り消しができませんでした。'
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
