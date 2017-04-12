class Admin::BotsController < ApplicationController
  include JudgeUserRole
  before_action :authenticate_staff_user

  def index
    @bots = Bot.all
  end
end
