class Api::Bots::ChatFailedMessagesController < Api::BaseController
  include ApiRespondable
  include FailedMessageHandleable

  def create
    _, bot_message = *create_messages_for_failed

    respond_to do |format|
      format.json { render json: bot_message, adapter: :json }
    end
  end
end
