module ChatsHelper
  def chat_page?
    request.path.start_with?('/embed/')
  end
end
