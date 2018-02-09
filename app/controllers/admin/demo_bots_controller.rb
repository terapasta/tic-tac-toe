class Admin::DemoBotsController < ApplicationController

  def index
    @demobots = Bot.where(is_demo: true).order(created_at: :desc)
  end

end