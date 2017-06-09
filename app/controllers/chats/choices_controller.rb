class Chats::ChoicesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat_decision_branch

  def create
    if @answer.present?
      ActiveRecord::Base.transaction do
        @message = @chat.messages.create!(guest_message_params)
        @bot_message = @chat.messages.create!(bot_message_params)
        @bot_messages = [@bot_message]
      end
    end
    respond_to do |format|
      format.js { render 'chats/messages/create' }
      format.json { render json: [@message, @bot_message], adapter: :json, include: 'answer,answer.decision_branches,similar_question_answers' }
    end
  end

  private
    def set_bot_chat_decision_branch
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.where(guest_key: session[:guest_key]).last
      @decision_branch = @chat.bot.decision_branches.find(params[:id])
      @answer = @decision_branch.next_answer
    end

    def guest_message_params
      {
        speaker: 'guest',
        body: @decision_branch.body
      }
    end

    def bot_message_params
      {
        speaker: 'bot',
        answer_id: @answer.id,
        body: @answer.body,
        created_at: @message.created_at + 1.second,
      }
    end
end
