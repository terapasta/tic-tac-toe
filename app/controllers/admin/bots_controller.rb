class Admin::BotsController < ApplicationController
  before_action :authenticate_staff_user

  def index
    @bots = Bot.all
  end

  private
    def authenticate_staff_user
      if current_user.role != 'staff'
        flash[:alert] = '管理者用ページです。権限があるアカウントでログインしてください。'
        redirect_to root_path
      end
    end
end
