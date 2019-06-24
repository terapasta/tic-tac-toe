class Api::Bots::ChatFailedMessagesController < Api::BaseController
  include ApiRespondable
  include ApiChatOperable
  include NotApplicableMessageHandleable

  def create
    guest_key = params.require(:guest_key)
    # Web版（chats)と外部連携API（api/bots)とでtokenの取り方が違うため条件分岐
    token = params[:token].present? ? params.require(:token) : params.require(:bot_token)
    message = params.require(:message)

    guest_message, bot_message = *create_messages_for_failed(guest_key, token, message)

    json = if myope_client?
      [guest_message, bot_message]
    else
      bor_message
    end

    respond_to do |format|
      format.json { render json: json, adapter: :json }
    end
  end

  private

  def included_associations
    'question_answer,question_answer.decision_branches,similar_question_answers,question_answer.answer_files'
  end
end
