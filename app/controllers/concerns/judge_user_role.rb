module JudgeUserRole
  extend ActiveSupport::Concern

  def authenticate_staff_user
    if current_user.role != 'staff'
      flash[:alert] = '管理者用ページです。権限があるアカウントでログインしてください。'
      redirect_to root_path
    end
  end
end
