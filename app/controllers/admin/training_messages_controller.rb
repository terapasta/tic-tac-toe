class Admin::TrainingMessagesController < ApplicationController
  before_action :authenticate_staff_user
  before_action :set_bot
  before_action :set_training_message, only: [:edit, :update]

  def edit
  end

  def update
    if @training_message.update(training_message_params)
      redirect_to admin_bot_next_path(@bot), notice: '登録しました。'
    else
      render :edit
    end
  end

  def next
    training_message = @bot.training_messages.guest.select{|m| m.tag_list.blank?}.sample
    redirect_to edit_admin_bot_training_message_path(@bot, training_message)
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end

    def set_training_message
      @training_message = TrainingMessage.find(params[:id])
    end

    def training_message_params
      params.require(:training_message).permit(:tag_list)
    end

    def authenticate_staff_user
      if current_user.role != 'staff'
        flash[:alert] = '管理者用ページです。権限があるアカウントでログインしてください。'
        redirect_to root_path
      end
    end
end
