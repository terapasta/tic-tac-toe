class Chats::ChatFailedMessagesController < Api::BaseController
  include ApiRespondable
  include FailedMessageHandleable

  def create
    render_collection_json create_messages_for_failed, status: :created
  end
end
