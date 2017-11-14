class My::NotificationsController < My::BaseController
  def update
    user_params = params.require(:user).permit(:email_notification)
    if @user.update(user_params)
      redirect_to edit_my_notification_path, notice: '通知を更新しました'
    else
      flash.now.alert = '通知を更新できませんでした'
      render :edit
    end
  end
end