class Chats::MessagesController < ApplicationController
  include Replyable
  include ApiRespondable
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat

  def index
    @messages = @chat.messages.order(created_at: :desc).page(params[:page]).per(20)
    respond_to do |format|
      format.json { render_collection_json @messages, reverse: true, include: 'answer,answer.decision_branches' }
    end
  end

  def create
    @bot = Bot.find_by!(token: params[:token])
    ActiveRecord::Base.transaction do
      @message = @chat.messages.create!(message_params) {|m|
        m.speaker = 'guest'
        m.user_agent = request.env['HTTP_USER_AGENT']
      }
      @bot_messages = receive_and_reply!(@chat, @message, params[:message][:other_answer_id])
    end
    respond_to do |format|
      format.js
      format.json { render_collection_json [@message, *@bot_messages], include: 'answer,answer.decision_branches,similar_question_answers' }
    end
  rescue => e
    logger.error e.message + e.backtrace.join("\n")
    respond_to do |format|
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private
    def set_bot_chat
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.find_last_by!(session[:guest_key])
    end

    def message_params
      params.require(:message).permit(:answer_id, :body)
    end
end
