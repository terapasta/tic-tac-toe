class ReplyResponse
  attr_reader :raw_data, :question

  def initialize(raw_data, bot, question, raw_question)
    @raw_data = raw_data
    @bot = bot
    @question = question
    @raw_question = raw_question
  end

  def effective_results
    @effective_results ||= @raw_data[:results].select{ |it|
      it[:probability] > @bot.candidate_answers_threshold
    }
  end

  def found_probable_answer?
    not question_answer.no_classified?
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
      question_answer_id,
      @bot,
      probability,
      classify_threshold
    )
  end

  def probability
    effective_results.first.try(:[], :probability) || 1
  end

  def probabilities
    effective_results.blank? ? [1] : effective_results.map { |it| it.try(:[], :probability) }
  end

  def confident?
    probabilities.length > 1 ? probabilities[0] - probabilities[1] >= @bot.top_candidate_answers_threshold : true
  end

  def similar_question_answers
    # effective_results への shift により、probability の結果が変わるため、コピーで処理を行う。
    # https://www.pivotaltracker.com/story/show/163612187
    results = effective_results.dup

    # ユーザーの質問に対して一致度の高い質問が見つかり、かつ
    # 「こちらの質問ではないですか？」が表示されない場合
    # 結果から最も確度の高い物を削除して回答として表示する
    # 一致度の高い質問が見つかり、上位二つの質問の確率が近い場合も同様の処理を行う
    results.shift if (found_probable_answer? & !show_similar_question_answers?) || (show_similar_question_answers? & !confident? & (probability > 0.9))

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
      # 名詞１語のみの質問の場合、回答の確度が低いので類似する質問を強制的に表示する
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
    # 以下のいずれかの条件に合致する場合は true、そうでなければ false
    # 1. 最も一致度の高い質問の確率が、サジェストを表示する閾値を（下方に）超えている
    # 2. 最も一致度の高い質問の確率が 0.9 以下で、かつ質問の文字数が 5以下である
    # 3. 最も一致度の高い質問の確率が 0.9 以下で、かつ質問の素性の数が 2以下である
    # 4. 一致度上位二つの質問の確率の差が設定値を下回る
    #
    # 要するに、ある程度の確度があっても、あらかじめ設定した閾値を超えられないか、
    # 同様にある程度の確度があっても、短すぎる質問に対しては
    # よほど一致率が高くない限りは強制的に類似する質問を表示する
    #
    # また、一致度上位二つの質問の確率が近い場合も自信がないものとして類似する質問を表示する。

    probability < threshold_of_suggest_similar_questions ||
    (probability < 0.9 && @question.length <= 5) ||
    (probability < 0.9 && question_feature_count <= 2) ||
    !confident?
  end

  def body
    question_answer.answer
  end

  def answer_failed
    question_answer.no_classified?
  end

  def render_has_suggests_message
    @bot.render_has_suggests_message(@raw_question)
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