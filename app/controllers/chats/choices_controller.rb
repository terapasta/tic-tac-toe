class Chats::ChoicesController < ApplicationController
  before_action :set_chat
  before_action :set_decision_branch

  def create
    answer = @decision_branch.next_answer
    @message = @chat.messages.build(speaker: 'guest', body: @decision_branch.body)
    @bot_messages = [ @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body) ]
    @chat.save!
    render 'chats/messages/create'
    # TODO 社員証紛失時のオペレーションのデモ用
    # if help_answer.id == 8  # デモ用のハードコーディング
    #   @help_answers.concat(HelpAnswer.where(id: [10,11,12]))
    # end
  end

  private
    def set_chat
      @chat = Chat.where(guest_key: session[:guest_key]).last
    end

    def set_decision_branch
      @decision_branch = @chat.bot.decision_branches.find(decision_branch_params[:id])
    end

    def decision_branch_params
      params.require(:decision_branch).permit(:id)
    end
end
