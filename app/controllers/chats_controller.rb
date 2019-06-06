class ChatsController < ApplicationController
  include ChatOperable

  def show
    set_bot
    set_guest_key
    set_guest_user
    @chat = @bot.chats.where(guest_key: guest_key).order(created_at: :desc).first
    if @chat.nil?
      redirect_to new_chats_path(token: params[:token], noheader: params[:noheader])
    else
      authorize @chat
      if need_password_view?
        render_password_view
      end
    end
  end

  def new
    set_bot
    set_guest_key
    set_guest_user
    @chat = @bot.chats.create_by(guest_key: guest_key) do |chat|
      authorize chat
      chat.is_staff = true if current_user.try(:staff?)
      chat.is_normal = true if current_user.try(:normal?)
    end
    if need_password_view?
      render_password_view
    else
      render :show
    end
  end

  private
    def chat_path
      chats_path(@bot.token)
    end
end
