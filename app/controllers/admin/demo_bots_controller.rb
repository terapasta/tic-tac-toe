class Admin::DemoBotsController < ApplicationController
  protect_from_forgery except: :update 
  before_action :set_demobot, only: [:update]

  def index
    @demobots = Bot.where(is_demo: true).order(created_at: :desc)
  end

  def update
    if @demobot.update_attributes(token: regenerate_token)
      @orgs = @demobot.organizations.all
      @orgs.each do |org|
        @users = org.users.all
        @users.each do |user|
          repassword = reset_password
          user.update_attributes(password: repassword, password_confirmation: repassword)
        end
      end
      redirect_to admin_demo_bots_path
    else
      render :index
    end
  end

  private
    def set_demobot
      @demobot = Bot.find(params[:id])
    end

    def regenerate_token
      SecureRandom.hex(32)
    end

    def reset_password
      SecureRandom.hex(10)
    end
end