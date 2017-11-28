class Admin::TutorialsController < ApplicationController
  before_action :set_bot, only: [:create, :edit, :update, :destroy]

  def index
    @bots = Bot.all
  end

  def create
    if @bot.create_tutorial
      redirect_to admin_tutorials_path, notice: 'Succeeded creating tutorial'
    else
      @bots = Bot.all
      flash.now.alert = 'Failed creating tutorial'
      render :index
    end
  end

  def edit
    @tutorial = @bot.tutorial
  end

  def update
    if @bot.tutorial.update(permitted_attributes(@bot.tutorial))
      redirect_to edit_admin_tutorial_path(bot_id: @bot.id), notice: 'Succeeded updating tutorial'
    else
      @tutorial = @bot.tutorial
      flash.now.alert = 'Failed updating tutorial'
      render :edit
    end
  end

  def destroy
    @bot.tutorial.destroy!
    redirect_to admin_tutorials_path, notice: 'Succeeded deleting tutorial'
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end
end