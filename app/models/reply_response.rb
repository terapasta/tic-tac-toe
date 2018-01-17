class ReplyResponse
  attr_reader :raw_data

  def initialize(raw_data, bot, question)
    @raw_data = raw_data
    @bot = bot
    @question = question
  end

  def effective_results
    @effective_results ||= @raw_data[:results].select{ |it|
      it[:probability] > 0.1
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
    ids = question_answer_ids.drop(1)
    qas = @bot.question_answers.where(id: ids).for_suggestion
    question_answer_ids.map{ |id| qas.detect{ |x| id == x.id } }.compact
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
        return lp.classify_threshold if lp.classify_threshold > 0.9
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

  private
    def threshold_of_suggest_similar_questions
      @bot.learning_parameter&.similar_question_answers_threshold ||
        MyOpeConfig.threshold_of_suggest_similar_questions
    end
end