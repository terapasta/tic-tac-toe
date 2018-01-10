class Chats::ChoicesController < ApplicationController
  include GuestKeyUsable
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat_decision_branch

  def create
    ActiveRecord::Base.transaction do
      @message = @chat.messages.create!(guest_message_params)
      @bot_message = @chat.messages.create!(bot_message_params)
    end
    respond_to do |format|
      format.js { render 'chats/messages/create' }
      format.json { render json: [@message, @bot_message], adapter: :json, include: 'child_decision_branches,similar_question_answers' }
    end
  end

  private
    def set_bot_chat_decision_branch
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.where(guest_key: guest_key).last
      @decision_branch = @chat.bot.decision_branches.find(params[:id])
    end

    def guest_message_params
      {
        speaker: 'guest',
        body: @decision_branch.body,
        created_at: @chat.messages.last.created_at + 1.second,
      }
    end

    def bot_message_params
      answer = @decision_branch.answer_or_answer_link_text
      {
        decision_branch_id: @decision_branch.id,
        speaker: 'bot',
        body: answer.presence || @bot.classify_failed_message.presence || DefinedAnswer.classify_failed_text,
        created_at: @message.created_at + 1.second,
        answer_failed: answer.blank?,
      }
    end
end
