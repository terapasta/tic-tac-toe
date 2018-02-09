class Admin::DemoBotsController < ApplicationController

  def index
    @demobots = Bot.where(is_demo: true).order(created_at: :desc)
  end

  def update
    redirect_to admin_demo_bots_path
  end

end