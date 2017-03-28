class Chats::ChoicesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat_decision_branch

  def create
    answer = @decision_branch.next_answer
    @message = @chat.messages.build(speaker: 'guest', body: @decision_branch.body)
    @bot_messages = [ @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body) ]
    @chat.save!
    respond_to do |format|
      format.html { render 'chats/messages/create' }
      format.json { render json: [@message, *@bot_messages], adapter: :json }
    end
  end

  private
    def set_bot_chat_decision_branch
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.where(guest_key: session[:guest_key]).last
      @decision_branch = @chat.bot.decision_branches.find(params[:id])
    end
end
