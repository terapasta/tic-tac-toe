class Conversation::Bot
  attr_accessor :states

  # HACK たぶん使われていないので削除する
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(bot, message)
    @bot = bot
    @message = message
    @ModelClass = message.class
    @engine = Ml::Engine.new(@bot)
    @word_mappings = WordMapping.for_bot(@bot).decorate
    @question_text = @bot.learning_parameter&.use_similarity_classification ?
      @word_mappings.replace_synonym(@message.body) : @message.body
  end

  def do_reply
    Rails.logger.debug("Conversation::Bot#reply body: #{@question_text}")

    result = @engine.reply(@question_text)
    @results = result[:results]

    question = @question_text
    question_feature_count = result[:question_feature_count]
    effective_results = @results.select{|x| x[:probability] > 0.1}
    question_answer_ids = effective_results.map{|x| x[:question_answer_id].to_i}
    question_answer_id = question_answer_ids.first
    probability = effective_results.first[:probability]
    Rails.logger.debug(probability)

    @question_answer = QuestionAnswer.find_or_null_question_answer(question_answer_id, @bot, probability, classify_threshold)
    
    reply = Conversation::Reply.new(question: question, question_feature_count: question_feature_count, question_answer: @question_answer, probability: probability, question_answer_ids: question_answer_ids)

    # HACK botクラスにcontactに関係するロジックが混ざっているのでリファクタリングしたい
    # HACK 開発をしやすくするためにcontact機能は一旦コメントアウト
    # if Answer::PRE_TRANSITION_CONTEXT_CONTACT_ID.include?(answer_id) && Service.contact.last.try(:enabled?)
    #   answers << ContactAnswer.find(ContactAnswer::TRANSITION_CONTEXT_CONTACT_ID)
    # end

    reply
  end

  def similar_question_answers_in(question_answer_ids)
    question_answers = @bot.question_answers.where(id: question_answer_ids)
    question_answer_ids.map{|id| question_answers.find{|x| id == x.id}}
  end

  private
    def classify_threshold
      learning_parameter = @bot.learning_parameter || LearningParameter.build_with_default
      learning_parameter.classify_threshold
    end
end
