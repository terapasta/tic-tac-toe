class Admin::DemoBotsController < ApplicationController
  before_action :set_demobots, only: [:index]
  before_action :set_demobot, only: [:update]

  def index
  end

  def update
    ActiveRecord::Base.transaction do
      @demobot.update!(token: new_token)
      @organization_users = User.includes(organizations: :bots).where(bots: {id: @demobot.id})
      @organization_users.each do |user|
        new_password = generate_password
        user.update!(password: new_password, password_confirmation: new_password)
      end
    end
      redirect_to admin_demo_bots_path
    rescue => e
      set_demobots
      flash.now.alert = e.message
      render :index
  end

  private
    def set_demobot
      @demobot = Bot.find(params[:id])
    end

    def set_demobots
      @demobots = Bot.where(is_demo: true).order(created_at: :desc)
    end

    def new_token
      SecureRandom.hex(32)
    end

    def generate_password
      SecureRandom.hex(10)
    end
end