class HelpdesksController < ApplicationController
  before_action :set_bot, only: [:new, :create, :destroy]
  before_action :check_have_start_message, only: :new

  def new
  end

  def create
    if params[:decision_branch_id].present?
      decision_branch = DecisionBranch.find(params[:decision_branch_id])
      help_answer = decision_branch.next_help_answer || @bot.start_answer
      @help_answers = [help_answer]
      # @help_answers << HelpAnswer.find(14) if help_answer.try(:decision_branches).try(:blank?)  # TODO 固定値を修正したい
      if help_answer.id == 8  # デモ用のハードコーディング
        @help_answers.concat(HelpAnswer.where(id: [10,11,12]))
      end
    else
      result = Ml::Engine.new(@bot.id).helpdesk_reply(params[:body])
      help_answer = HelpAnswer.find(result['help_answer_id'])
      @help_answers = [help_answer]
    end
  end

  private
    def set_bot
      # HACK URL内のIDを変更すれば、他社のbotも表示出来てしまうため、いずれはトークンなどによるbot識別をする必要がある
      @bot = Bot.find(params[:bot_id])
    end

    # TODO DRYにしたい
    def check_have_start_message
      if @bot.start_answer.blank?
        flash[:error] =  'Bot編集画面で開始メッセージを指定してください'
        redirect_to :back
      end
    end
end
