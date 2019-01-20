class WsChatsController < ApplicationController
  include ChatOperable

  def show
    set_bot
    set_guest_key
    set_guest_user
    set_warning_message
    @chat = @bot.chats.find_or_create_by(
      guest_key: guest_key,
      is_staff: !!current_user.try(:staff?),
      is_normal: !!current_user.try(:normal?)
    )
    authorize @chat
    render_password_view if need_password_view?
  end

  private
    def chat_path
      ws_chat_path(@bot.token)
    end
end