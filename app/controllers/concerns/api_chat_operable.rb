module ApiChatOperable
  extend ActiveSupport::Concern

  private
    def websocket_client?
      request.headers['X-Chat-Client'] == 'MyOpeWebsocketChat'
    end

    def find_chat_service_user!(bot, guest_key)
      if websocket_client?
        nil
      else
        bot.chat_service_users.find_by!(guest_key: guest_key)
      end
    end
end