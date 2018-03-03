class Admin::DemoBotsController < ApplicationController

  def index
    set_demobots
  end

  def update
    @demobot = Bot.where(is_demo: true).find(params[:id])
    ActiveRecord::Base.transaction do
      @demobot.change_token!
      @demobot.organization_users.each(&:change_password!)
    end
      redirect_to admin_demo_bots_path
    rescue => e
      set_demobots
      flash.now.alert = e.message
      render :index
  end

  private
    def set_demobots
      @demobots = Bot.where(is_demo: true).order(created_at: :desc)
    end
end