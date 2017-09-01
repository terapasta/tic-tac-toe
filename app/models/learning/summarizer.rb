class Learning::Summarizer
  def initialize(bot)
    @bot = bot
  end

  def summary
    ActiveRecord::Base.transaction do
      LearningTrainingMessage.where(bot: @bot).delete_all
      convert_question_answers!
      convert_decision_branches!
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

      # NOTE @bot.learning_training_messagesを使うと不要なアソシエーションされたモデルが作られるので余計にレコードを保存してしまう
      ltm = LearningTrainingMessage.find_or_initialize_by(
        bot_id: @bot.id,
        question: qa.question,
      )

      # NOTE Answer廃止でQuestionAnswerに統一したら上のfindする時にquestion_answer_idを使用するけど今はセットしておくだけ
      ltm.assign_attributes(
        question_answer_id: qa.id,
        answer_body: qa.answer
      )

      res << ltm
      res
    }
    LearningTrainingMessage.import!(data, on_duplicate_key_update: [:id])
  end

  def convert_decision_branches!
    @bot.question_answers.find_each do |qa|
      next if qa.answer.blank? || qa.underlayer.blank?

      current_answer = qa.answer
      qa.underlayer.each_slice(2) do |db_body, a_body|
        db = current_answer.decision_branches.find_or_initialize_by(
          body: db_body,
          bot_id: @bot.id
        )
        if a_body.present?
          # NOTE current_answerを更新して次のループに渡す
          current_answer = @bot.answers.find_or_initialize_by(
            body: a_body,
            bot_id: @bot.id
          )
          db.next_answer = current_answer
        end
        db.save!
      end
    end
  end
end
