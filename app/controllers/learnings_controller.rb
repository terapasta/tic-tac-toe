class LearningsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def update
    LearnJob.perform_later(@bot.id)
    @bot.update learning_status: :processing, learning_status_changed_at: Time.current

    redirect_to [:edit, @bot], notice: '学習処理が開始されました。結果が反映されない場合は、数秒〜数分待って試してください。'
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end
end
