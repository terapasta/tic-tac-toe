class HelpdesksController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_chat, only: [:show, :destroy]
  before_action :set_bot, only: [:new, :create, :destroy]
  # before_action :set_guest_key
  before_action :check_have_start_message, only: :new
  #
  # def show
  #   session[:embed] = params[:embed] if params[:embed]
  #   redirect_to new_chats_path if @chat.nil?
  # end
  #
  def new
    # @chat = @bot.chats.new(guest_key: session[:guest_key])
    # @chat.messages << @chat.build_start_message
    # @chat.save!
    # render :show
  end

  def create
    if params[:decision_branch_id].present?
      decision_branch = DecisionBranch.find(params[:decision_branch_id])
      help_answer = decision_branch.next_help_answer || @bot.start_answer
      @help_answers = [help_answer]
      @help_answers << HelpAnswer.find(14) if help_answer.try(:decision_branches).try(:blank?)  # TODO 固定値を修正したい
    else
      result = Ml::Engine.new(@bot.id).helpdesk_reply(params[:body])
      help_answer = HelpAnswer.find(result['help_answer_id'])
      @help_answers = [help_answer]
    end
  end

  #
  # def destroy
  #   flash[:notice] = 'クリアしました'
  #   redirect_to new_bot_chats_path(@bot)
  # end
  #
  private
    def set_bot
      # HACK URL内のIDを変更すれば、他社のbotも表示出来てしまうため、いずれはトークンなどによるbot識別をする必要がある
      @bot = Bot.find(params[:bot_id])
    end
  #
  #   def set_chat
  #     @chat = Chat.where(guest_key: session[:guest_key]).last
  #   end
  #
  #   def set_guest_key
  #     session[:guest_key] ||= SecureRandom.hex(64)
  #   end
  #
    # TODO DRYにしたい
    def check_have_start_message
      if @bot.start_answer.blank?
        flash[:error] =  'Bot編集画面で開始メッセージを指定してください'
        redirect_to :back
      end
    end
  #
  #   def message_params
  #     params.require(:message).permit(:body)
  #   end
end
