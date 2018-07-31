class ChatTestJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |e|
    error = e.inspect + e.backtrace.join("\n")
    logger.error error
    Bot.find(@bot.id).tap do |bot|
      bot.update(is_chat_test_processing: false, chat_test_job_error: error)
    end
  end

  def perform(bot, raw_data)
    @bot = bot # for error handling
    engine = Ml::Engine.new(@bot)
    word_mappings = WordMapping.for_bot(@bot).decorate
    data = CSV.parse(raw_data).map(&:first)

    if @bot.use_similarity_classification?
      data.map!{ |it| word_mappings.replace_synonym(it) }
    end

    reply_responses = engine.replies(data)[:data].map.with_index{ |raw_data, i|
      ReplyResponse.new(raw_data, @bot, data[i], data[i])
    }
    ids = reply_responses.map(&:resolved_question_answer_id)
    qas = QuestionAnswer.find_all_or_null_question_answers(ids, @bot)
    suggests = reply_responses.map{ |it| it.similar_question_answers.map(&:question) }
    chat_test_results = qas.map.with_index{ |qa, i|
      reply_response = reply_responses[i]
      [
        data[i].scrub,
        (
          reply_response.is_need_has_suggests_message? ?
          reply_response.render_has_suggests_message :
          qa.answer.scrub
        ),
        suggests[i]
      ]
    }

    @bot2 = Bot.find(@bot.id)
    @bot2.assign_attributes(
      chat_test_results: chat_test_results,
      is_chat_test_processing: false
    )
    @bot2.save!
  end
end