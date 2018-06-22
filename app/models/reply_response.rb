class ReplyResponse
  attr_reader :raw_data, :question

  def initialize(raw_data, bot, question)
    @raw_data = raw_data
    @bot = bot
    @question = question
  end

  def effective_results
    @effective_results ||= @raw_data[:results].select{ |it|
      it[:probability] > @bot.candidate_answers_threshold
    }
  end

  def question_answer_ids
    @question_answer_ids ||= begin
      if effective_results.count.zero?
        [QuestionAnswer::NO_CLASSIFIED_ID]
      else
        effective_results.map{ |it|
          it[:question_answer_id].to_i
        }
      end
    end
  end

  def question_answer_id
    question_answer_ids.first
  end

  def question_answer
    @question_answer ||= QuestionAnswer.find_or_null_question_answer(
      question_answer_ids.first,
      @bot,
      probability,
      classify_threshold
    )
  end

  def probability
    effective_results.first.try(:[], :probability) || 1
  end

  def similar_question_answers
    results = effective_results
    results.shift if classify_threshold < 0.9 && !show_similar_question_answers?
    SimilarQuestionAnswersFinder.new(bot: @bot, results: results).process
  end

  def question_feature_count
    @raw_data[:question_feature_count]
  end

  def noun_count
    @raw_data[:noun_count]
  end

  def verb_count
    @raw_data[:verb_count]
  end

  def classify_threshold
    @classify_threshold ||= begin
      lp = @bot.learning_parameter || LearningParameter.build_with_default
      if noun_count == 1 && verb_count.zero?
        # lp.classify_thresholdが0.9以上だったらこれを返す
        return lp.classify_threshold if lp.classify_threshold >= 0.9
        0.9
      else
        lp.classify_threshold
      end
    end
  end

  def resolved_question_answer_id
    if probability < classify_threshold
      QuestionAnswer::NO_CLASSIFIED_ID
    else
      question_answer_id
    end
  end

  def show_similar_question_answers?
    probability < threshold_of_suggest_similar_questions ||
    (probability < 0.9 && @question.length <= 5) ||
    (probability < 0.9 && question_feature_count <= 2)
  end

  def body
    question_answer.answer
  end

  def answer_failed
    question_answer.no_classified?
  end

  def render_has_suggests_message
    @bot.render_has_suggests_message(@question)
  end

  def is_need_has_suggests_message?
    similar_question_answers.count > 0 && question_answer.no_classified?
  end

  def update_to_has_suggests_message_if_needed!(bot_message)
    return unless is_need_has_suggests_message?
    bot_message.body = render_has_suggests_message
    bot_message.update!(answer_failed: false, is_show_similar_question_answers: true)
  end

  private
    def threshold_of_suggest_similar_questions
      @bot.learning_parameter&.similar_question_answers_threshold ||
        MyOpeConfig.threshold_of_suggest_similar_questions
    end
end