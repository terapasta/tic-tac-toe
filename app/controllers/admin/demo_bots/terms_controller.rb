class Admin::DemoBots::TermsController < ApplicationController

  def destroy 
    @demobot = Bot.demos.find(params[:demo_bot_id])
    ActiveRecord::Base.transaction do
      @demobot.change_token_and_set_demo_finished_time!
      @demobot.organization_users.each(&:change_password!)
    end
    redirect_to admin_demo_bots_path
  rescue => e
    redirect_to admin_demo_bots_path, alert: e.message
  end

end