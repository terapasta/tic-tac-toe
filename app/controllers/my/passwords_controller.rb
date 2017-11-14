class My::PasswordsController < My::BaseController
  def update
    user_params = params.require(:user).permit(:current_password, :password, :password_confirmation)
    if @user.update_with_password(user_params)
      bypass_sign_in @user, scope: :user
      redirect_to edit_my_password_path, notice: 'パスワードを更新しました'
    else
      flash.now.alert = 'パスワードを更新できませんでした'
      render :edit
    end
  end
end