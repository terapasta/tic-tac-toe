module ReplyTestable
  extend ActiveSupport::Concern

  BotAccuracyStruct = Struct.new(
    :bot,
    :result
  )

  ResultStruct = Struct.new(
    :accuracy_test_cases,
    :success_count,
    :accuracy,
    :details
  )

  def all_bot_accuracy_test!
    Bot.all.map{ |bot| BotAccuracyStruct.new(bot, accuracy_test!(bot)) }
  end

  def accuracy_test!(bot)
    ResultStruct.new.tap do |result|
      result.accuracy_test_cases = bot.accuracy_test_cases.to_a
      questions = result.accuracy_test_cases.map(&:question_text)
      reply_responses = ReplyRequestService.new(bot, questions).process
      result.details = result.accuracy_test_cases.each_with_index.inject({}){ |acc, (it, i)|
        acc[it.id] = reply_responses[i]
        acc
      }
      result.success_count = result.accuracy_test_cases.select.with_index{ |it, i|
        it.success?(reply_responses[i])
      }.count
      result.accuracy = result.success_count.to_f / result.accuracy_test_cases.count.to_f
    end
  end
end
