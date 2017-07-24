class Chats::TrainingsController < ApplicationController
  before_action :set_bot_chat_messages

  def create
    ActiveRecord::Base.transaction do
      @question_answer = @bot.question_answers.create!(permitted_attributes(QuestionAnswer))
      @question_message.update_for_training_with!(@question_answer)
      @answer_message.update_for_training_with!(@question_answer)
    end
    render json: @question_answer, adapter: :json
  rescue => e
    logger.error e.message + e.backtrace.join("\n")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
    def set_bot_chat_messages
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.where(guest_key: session[:guest_key]).last
      @question_message = @chat.messages.find(params[:question_message_id])
      @answer_message = @chat.messages.find(params[:answer_message_id])
    end
end
