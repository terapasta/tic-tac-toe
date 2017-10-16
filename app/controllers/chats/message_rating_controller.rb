class Chats::MessageRatingController < ApplicationController
  include GuestKeyUsable
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat_message_rating

  def good
    @message.good!
    @rating.good!
    render json: @message, adapter: :json
  end

  def bad
    @message.bad!
    @rating.bad!
    SendBadRateMailService.new(@message, current_user).send_mail
    TaskCreateService.new(@message, @bot, current_user).process
    render json: @message, adapter: :json
  end

  def nothing
    @message.nothing!
    @rating.destroy!
    render json: @message, adapter: :json
  end

  private
    def set_bot_chat_message_rating
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.find_by_guest_key!(guest_key)
      @message = @chat.messages.find(params[:message_id])
      @rating = Rating.find_or_initialize_by(message_id: @message.id).tap { |rating|
        rating.message_id = @message.id
        rating.level = @message.rating
        rating.question_answer_id = @message.question_answer_id
        rating.bot_id = @bot.id
        rating.question = Message.find_pair_message_from(@message).body
        rating.answer = @message.body
        rating.save!
      }
    end
end
