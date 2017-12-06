class PagesController < ApplicationController
  def home
    if current_user
      redirect_to bots_path
    else
      redirect_to new_user_session_path
    end
  end

  def styleguide
    render layout: false
  end
end
