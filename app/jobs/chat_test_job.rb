class ChatTestJob < ApplicationJob
  queue_as :default
  include Replyable

  rescue_from StandardError do |e|
    logger.error e.inspect + e.backtrace.join("\n")
    Bot.find(@bot.id).tap do |bot|
      bot.update(is_chat_test_processing: false)
    end
  end

  def perform(bot, raw_data)
    @bot = bot # for error handling
    @engine = Ml::Engine.new(@bot)
    @word_mappings = WordMapping.for_bot(@bot).decorate
    @data = CSV.parse(raw_data).map(&:first)

    if @bot.use_similarity_classification?
      @data.map!{ |it| @word_mappings.replace_synonym(it) }
    end

    @replies = @engine.replies(@data)[:data]
    @question_answer_ids = @replies.map{ |it|
      Conversation::Bot.extract_results(@bot, it).question_answer_id
    }
    @question_answers = QuestionAnswer.where(id: @question_answer_ids).pluck(:id, :answer)
    @chat_test_results = @question_answer_ids.map.with_index{ |qa_id, i|
      answer = if qa_id.zero?
        NullQuestionAnswer.new(@bot).answer
      else
        @question_answers.detect{ |qa| qa[0] == qa_id }.second
      end
      [ @data[i], answer ]
    }

    @bot2 = Bot.find(@bot.id)
    @bot2.assign_attributes(
      chat_test_results: @chat_test_results,
      is_chat_test_processing: false
    )
    @bot2.save!
  end
end