class BotsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bots = current_user.bots
  end
end
