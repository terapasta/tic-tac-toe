class IpAddressesController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_ip_address, only: [:edit, :update, :destroy]

  def index
    @ip_addresses = @bot.ip_addresses
  end

  def new
    @ip_address = @bot.ip_addresses.build
  end

  def create
    @ip_address = IpAddress.new(ip_address_params)
    @ip_address.bot_id = @bot.id
    if @ip_address.save
      redirect_to bot_ip_addresses_path(@bot), notice: '登録しました。'
    else
      flash.now.alert = '登録できませんでした。'
      render :new
    end
  end

  def edit
  end

  def update
    if @ip_address.update(ip_address_params)
      redirect_to bot_ip_addresses_path(@bot), notice: '更新しました。'
    else
      flash.now.alert = '更新できませんでした。'
      render :edit
    end
  end

  def destroy
    @ip_address.destroy
    redirect_to bot_ip_addresses_path(@bot), notice: '削除しました。'
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_ip_address
      @ip_address = IpAddress.find(params[:id])
    end

    def ip_address_params
      params.require(:ip_address).permit(:permission)
    end
end
