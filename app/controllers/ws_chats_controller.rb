class WsChatsController < ApplicationController
  include ChatOperable

  def show
    set_bot
    set_guest_key
    set_guest_user
    @chat = @bot.chats.where(guest_key: guest_key).order(created_at: :desc).first
    if @chat.nil?
      @chat = @bot.chats.create_by(guest_key: guest_key) do |chat|
        authorize chat
        chat.is_staff = true if current_user.try(:staff?)
        chat.is_normal = true if current_user.try(:normal?)
      end
    else
      authorize @chat
    end
    render_password_view if need_password_view?
  end

  private
    def chat_path
      ws_chat_path(@bot.token)
    end
end