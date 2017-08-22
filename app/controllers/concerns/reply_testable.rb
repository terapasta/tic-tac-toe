module ReplyTestable
  extend ActiveSupport::Concern
  include Replyable

  def all_bot_accuracy_test!
    Bot.all.each do |bot|
      Struct.new(:bot, :result).new(
        bot,
        accuracy_test!(bot),
      )
    end
  end

  def accuracy_test!(bot)
    result = Struct.new(:accuracy_test_cases, :success_count, :accuracy, :details).new
    result.accuracy_test_cases = bot.accuracy_test_cases
    chat = bot.chats.create(guest_key: SecureRandom.hex(64))
    result.details = collect_results!(chat, result.accuracy_test_cases)
    result.success_count = result.accuracy_test_cases.select{ |a|
      a.success_result?(result.details[a.id])
    }.count
    result.accuracy = result.success_count.to_f / result.accuracy_test_cases.count.to_f
    result
  end

  private
    def collect_results!(chat, accuracy_test_cases)
      results = {}
      ActiveRecord::Base.transaction do
        accuracy_test_cases.each do |accuracy_test_case|
          message = chat.messages.create!(
            body: accuracy_test_case.question_text,
            speaker: 'guest',
          )
          bot_messages = receive_and_reply!(chat, message)
          results[accuracy_test_case.id] = bot_messages
        end
        raise ActiveRecord::Rollback
      end
     results 
    end
end
