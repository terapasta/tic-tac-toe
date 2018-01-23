class Learning::Summarizer
  def initialize(bot)
    @bot = bot
  end

  def summary
    ActiveRecord::Base.transaction do
      LearningTrainingMessage.where(bot: @bot).delete_all
      convert_question_answers!
    end
  end

  def unify_learning_training_message_words!
    @word_mappings ||= WordMapping.for_bot(@bot).decorate
    @bot.learning_training_messages.each do |it|
      it.question = @word_mappings.replace_synonym(it.question)
    end
    @bot.learning_training_messages.each(&:save!)
  end

  def convert_question_answers!
    data = @bot.question_answers.all.inject([]) { |res, qa|
      next res if qa.answer.blank? || res.map(&:question).include?(qa.question)

      res << create_learning_training_message(qa.id, qa.question, qa.answer)

      qa.sub_questions.pluck(:question).each do |sub_question|
        res << create_learning_training_message(qa.id, sub_question, qa.answer, true)
      end

      res
    }
    LearningTrainingMessage.import!(data, on_duplicate_key_update: [:id])
  end

  private
    def create_learning_training_message(id, question, answer, is_sub_question = false)
      # NOTE @bot.learning_training_messagesを使うと不要なアソシエーションされたモデルが作られるので余計にレコードを保存してしまう
      LearningTrainingMessage.find_or_initialize_by(
        bot_id: @bot.id,
        question: question,
        is_sub_question: is_sub_question
      ).tap do |ltm|
        # NOTE Answer廃止でQuestionAnswerに統一したら上のfindする時にquestion_answer_idを使用するけど今はセットしておくだけ
        ltm.assign_attributes(
          question_answer_id: id,
          answer_body: answer
        )
      end
    end
end
