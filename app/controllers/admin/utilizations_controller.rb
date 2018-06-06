class Admin::UtilizationsController < ApplicationController
  CookieKey = :watching_bot_ids

  def index
    @watching_bot_ids = watching_bot_ids
    if @watching_bot_ids.blank? || params[:selecting].present?
      render :bot_selector and return
    end
    @bots = Bot.where(id: cookies[CookieKey].split(','))
  end

  def create
    cookies[CookieKey] = params[:bot_ids].map(&:to_i).join(',')
    redirect_to admin_utilizations_path
  end

  private
    def watching_bot_ids
      (cookies[CookieKey].presence || '').split(',').map(&:to_i)
    end
end