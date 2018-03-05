class Admin::DemoBotsController < ApplicationController

  def index
    @demobots = Bot.demos.order(created_at: :desc)
  end

end