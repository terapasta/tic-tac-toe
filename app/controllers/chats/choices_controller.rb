class Chats::ChoicesController < ApplicationController
  before_action :set_chat
  before_action :set_decision_branch

  def create
    @bot = @chat.bot
    answer = @decision_branch.next_answer
    @message = @chat.messages.build(speaker: 'guest', body: @decision_branch.body)
    @bot_messages = [ @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body) ]
    @chat.save!
    render 'chats/messages/create'
  end

  private
    def set_chat
      @chat = Chat.where(guest_key: session[:guest_key]).last
    end

    def set_decision_branch
      @decision_branch = @chat.bot.decision_branches.find(params[:id])
    end
end
