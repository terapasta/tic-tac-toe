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
    @word_mappings = WordMapping.for_user(@bot.user).decorate
    @question_text = @bot.learning_parameter&.use_similarity_classification ?
      @word_mappings.replace_synonym(@message.body) : @message.body
  end

  def do_reply
    Rails.logger.debug("Conversation::Bot#reply body: #{@question_text}")

    result = @engine.reply(@question_text)
    @results = result[:results]

    answer_id = result[:answer_id]
    probability = result[:probability]
    question = result[:question]
    question_feature_count = result[:question_feature_count]
    question_answer_ids = @results.select{|x| x[:probability] > 0.1}.map{|x| x[:question_answer_id].to_i}
    Rails.logger.debug(probability)

    @answer = Answer.find_or_null_answer(answer_id, @bot, probability, classify_threshold)
    reply = Conversation::Reply.new(question: question, question_feature_count: question_feature_count, answer: @answer, probability: probability, question_answer_ids: question_answer_ids)

    # HACK botクラスにcontactに関係するロジックが混ざっているのでリファクタリングしたい
    # HACK 開発をしやすくするためにcontact機能は一旦コメントアウト
    # if Answer::PRE_TRANSITION_CONTEXT_CONTACT_ID.include?(answer_id) && Service.contact.last.try(:enabled?)
    #   answers << ContactAnswer.find(ContactAnswer::TRANSITION_CONTEXT_CONTACT_ID)
    # end

    reply
  end

  def similar_question_answers_in(question_answer_ids)
    @bot.question_answers.where(id: question_answer_ids)
  end

  private
    def classify_threshold
      learning_parameter = @bot.learning_parameter || LearningParameter.build_with_default
      learning_parameter.classify_threshold
    end
end
