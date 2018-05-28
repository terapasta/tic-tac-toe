class Learning::Summarizer
  def initialize(bot)
    @bot = bot
  end

  def summary
    ActiveRecord::Base.transaction do
      LearningTrainingMessage.where(bot: @bot).delete_all
      data = @bot.question_answers.pluck(:id, :question_wakati, :answer).map{ |qa|
        datum = {
          bot_id: @bot.id,
          question_answer_id: qa[0],
          question: qa[1],
          answer_body: qa[2]
        }
        sq_data = SubQuestion.where(question_answer_id: qa[0]).pluck(:id, :question_wakati).map{ |sqa| {
          sub_question_id: sqa[0],
          bot_id: @bot.id,
          question_answer_id: qa[0],
          question: sqa[1],
          answer_body: qa[2]
        } }
        [datum, *sq_data].map{ |d| LearningTrainingMessage.new(d) }
      }.flatten
      LearningTrainingMessage.import(data)
      # convert_question_answers!
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
      res + [qa, *qa.sub_questions.to_a].map{ |q| build_learning_training_message(q) }
    }
    LearningTrainingMessage.import!(data, on_duplicate_key_update: [:id])
  end

  private
    def build_learning_training_message(record)
      # NOTE @bot.learning_training_messagesを使うと不要なアソシエーションされたモデルが作られるので余計にレコードを保存してしまう
      LearningTrainingMessage.find_or_initialize_by(
        bot_id: @bot.id,
        question_answer_id: (record.sub_question? ? record.question_answer_id : record.id),
        question: record.question,
        sub_question_id: (record.sub_question? ? record.id : nil)
      )
    end
end
