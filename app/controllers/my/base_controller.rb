class My::BaseController < ApplicationController
  before_action :set_user

  private
    def set_user
      @user = current_user
    end
end