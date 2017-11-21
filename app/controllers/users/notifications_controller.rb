class Users::NotificationsController < ApplicationController
  def edit
  end

  def update
    switch = params[:email] == 1 ? 'on' : 'off'
    current_user.public_send("turn_email_notification_#{switch}")
    if current_user.save
      redirect_to edit_user_notification_path, notice: '通知設定を更新しました'
    else
      flash.now.alert = '通知設定を更新できませんでした'
      render :edit
    end
  end
end