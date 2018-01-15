class Conversation::Bot
  attr_accessor :states

  # HACK たぶん使われていないので削除する
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  NO_CLASSIFIED_ANSWER_ID = 0

  def initialize(bot, message)
    @bot = bot
    @message = message
    @ModelClass = message.class
    @engine = Ml::Engine.new(@bot)
    @word_mappings = WordMapping.for_bot(@bot).decorate
    @question_text = @bot.use_similarity_classification? ?
      @word_mappings.replace_synonym(@message.body) : @message.body
  end

  def self.extract_results(bot, reply)
    selected = reply[:results].select{ |it| it[:probability] > 0.1 }
    if selected.length == 0
      question_answer_ids = [NO_CLASSIFIED_ANSWER_ID]
      question_answer_id = 0
      probability = 1
    else
      question_answer_ids = selected.map{ |it| it[:question_answer_id].to_i }
      question_answer_id = question_answer_ids.first
      probability = selected.first[:probability]
    end
    classify_threshold = resolve_classify_threshold(bot, reply[:noun_count], reply[:verb_count])
    Hashie::Mash.new(
      question_answer_ids: question_answer_ids,
      question_answer_id: question_answer_id,
      probability: probability,
      classify_threshold: classify_threshold
    )
  end

  def self.resolve_classify_threshold(bot, noun_count, verb_count)
    # NOTE 質問文の中に名詞が１つだったらサジェストを積極的に出せるようにする
    return 0.9 if noun_count == 1 && verb_count == 0
    learning_parameter = bot.learning_parameter || LearningParameter.build_with_default
    learning_parameter.classify_threshold
  end

  def do_reply
    Rails.logger.debug("Conversation::Bot#reply body: #{@question_text}")

    reply = @engine.reply(@question_text)
    extract = self.class.extract_results(@bot, reply)
    Rails.logger.debug(extract.probability)

    @question_answer = QuestionAnswer.find_or_null_question_answer(
      extract.question_answer_id,
      @bot,
      extract.probability,
      extract.classify_threshold
    )

    Hashie::Mash.new(
      question: @question_text,
      question_feature_count: reply[:question_feature_count],
      question_answer: @question_answer,
      probability: extract.probability,
      question_answer_ids: extract.question_answer_ids,
      raw_data: result
    )
  end

  def similar_question_answers_in(question_answer_ids, without_id: nil)
    question_answers = @bot.question_answers.where(id: question_answer_ids).for_suggestion
    question_answers = question_answers.where.not(id: [without_id]) if without_id.present?
    question_answer_ids.map{|id| question_answers.find{|x| id == x.id}}
  end

  private
    def resolve_classify_threshold(noun_count, verb_count)
      self.class.resolve_classify_threshold(@bot, noun_count, verb_count)
    end
end
