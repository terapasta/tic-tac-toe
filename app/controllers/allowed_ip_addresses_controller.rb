class AllowedIpAddressesController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_allowed_ip_address, only: [:edit, :update, :destroy]

  def index
    authorize AllowedIpAddress
    @allowed_ip_addresses = @bot.allowed_ip_addresses
  end

  def new
    authorize AllowedIpAddress
    @allowed_ip_address = @bot.allowed_ip_addresses.build
  end

  def create
    @allowed_ip_address = @bot.allowed_ip_addresses.build(permitted_attributes(AllowedIpAddress))
    @allowed_ip_address.bot_id = @bot.id
    authorize @allowed_ip_address
    if @allowed_ip_address.save
      redirect_to bot_allowed_ip_addresses_path(@bot), notice: '登録しました。'
    else
      flash.now.alert = '登録できませんでした。'
      render :new
    end
  end

  def edit
  end

  def update
    if @allowed_ip_address.update(permitted_attributes(@allowed_ip_address))
      redirect_to bot_allowed_ip_addresses_path(@bot), notice: '更新しました。'
    else
      flash.now.alert = '更新できませんでした。'
      render :edit
    end
  end

  def destroy
    @allowed_ip_address.destroy
    redirect_to bot_allowed_ip_addresses_path(@bot), notice: '削除しました。'
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_allowed_ip_address
      @allowed_ip_address = AllowedIpAddress.find(params[:id])
      authorize @allowed_ip_address
    end
end
