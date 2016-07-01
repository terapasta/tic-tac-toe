class DashboardsController < ApplicationController
  before_action :authenticate_admin_user!

  def show
  end
end
