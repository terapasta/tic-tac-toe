class Admin::DemoBotsController < ApplicationController
  
  def index
    @demobots = Bot.where(is_demo: true).order(created_at: :desc)
  end

  def update
    @demobot = Bot.find(params[:id])
    ActiveRecord::Base.transaction do
      @demobot.change_token
      @demobot.organization_users.each {|user| user.change_password}
    end
      redirect_to admin_demo_bots_path
    rescue => e
      @demobots = Bot.where(is_demo: true).order(created_at: :desc)
      flash.now.alert = e.message
      render :index
  end
end