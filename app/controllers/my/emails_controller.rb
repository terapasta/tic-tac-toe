class My::EmailsController < My::BaseController
  def update
    user_params = params.require(:user).permit(:email)
    if @user.update(user_params)
      redirect_to edit_my_email_path, notice: 'メールアドレスを更新しました'
    else
      flash.now.alert = 'メールアドレスを更新しました'
      render :edit
    end
  end
end