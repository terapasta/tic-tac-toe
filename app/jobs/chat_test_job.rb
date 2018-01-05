class ChatTestJob < ApplicationJob
  queue_as :default
  include Replyable

  rescue_from StandardError do |e|
    logger.error e.inspect + e.backtrace.join("\n")
    Bot.find(@bot.id).tap do |bot|
      bot.update(is_chat_test_processing: false)
    end
  end

  def perform(bot, current_user, raw_data)
    @bot = bot # for error handling
    ActiveRecord::Base.transaction do
      @chat = Chat.build_with_user_role(@bot, current_user)
      @chat.save
      CSV.parse(raw_data).each do |csv_data|
        message = @chat.messages.create!(body: csv_data[0]) { |m|
          m.speaker = 'guest'
          m.user_agent = 'chat test'
        }
        receive_and_reply!(@chat, message)
      end
      raise ActiveRecord::Rollback
    end
    @bot2 = Bot.find(@bot.id)
    @bot2.assign_attributes(
      chat_test_results: Message.build_for_bot_test(@chat),
      is_chat_test_processing: false
    )
    @bot2.save!
  end
end