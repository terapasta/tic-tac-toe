class ReplyResponse::SimilarQuestionAnswersFinder
  def initialize(bot:, results:)
    @bot = bot
    @results = results.map{ |it| Hashie::Mash.new(it) }
    @learning_training_messages = @bot.learning_training_messages.by_results(@results)
    @question_answer_ids = @results.map(&:question_answer_id)
  end

  def process
    @results.inject([]) { |acc, result|
      ltm = find_learning_training_message_by(result)
      qa = find_question_answer_by(result)
      if ltm.sub_question_id.present?
        acc + [find_sub_question_from(question_answer: qa, by_learning_training_message: ltm)]
      else
        acc + [qa]
      end
    }.compact
  end

  private
    def question_answers
      @question_answers ||= begin
        @bot.question_answers
          .includes(:sub_questions)
          .where(id: @question_answer_ids)
          .for_suggestion
      end
    end

    def find_learning_training_message_by(result)
      @learning_training_messages.detect{ |it|
        it.question_answer_id == result.question_answer_id && it.question == result.question
      }
    end

    def find_question_answer_by(result)
      question_answers.detect{ |it| it.id == result.question_answer_id }
    end

    def find_sub_question_from(question_answer:, by_learning_training_message:)
      question_answer.sub_questions.detect{ |it| it.id == by_learning_training_message.sub_question_id }
    end
end