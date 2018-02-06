class Admin::DemoBotsController < ApplicationController

  def index
    @organizations = Organization.order(created_at: :desc)
  end

end