class Admin::BotsController < ApplicationController
  before_action :authenticate_admin_user!

  def index
    @bots = Bot.all
  end
end
