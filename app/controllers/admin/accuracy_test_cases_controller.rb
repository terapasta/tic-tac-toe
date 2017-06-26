class Admin::AccuracyTestCasesController < ApplicationController
  include BotUsable
  before_action :authenticate_user!

  def index
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end
end
