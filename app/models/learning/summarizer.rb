class Learning::Summarizer
  include Learning::TagSummarizable

  def initialize(bot)
    @bot = bot
  end

  def summary
    LearningTrainingMessage.where(bot: @bot).destroy_all
    convert_question_answer!
    convert_decision_branches!
  end

  def convert_question_answer!
    learning_training_messages = []
    @bot.question_answer.find_each do |question_answer|
      learning_training_message = @bot.learning_training_messages.find_or_initialize_by(
        question: question_answer.question,
        answer_id: question_answer.answer_id
      )
      unless learning_training_messages.any? {|m| m.question == question_answer.question}
        learning_training_message.answer_body = question_answer.answer.body
        learning_training_messages << learning_training_message
      end
    end
    # merge_tag_ids!(learning_training_messages)
    LearningTrainingMessage.import!(learning_training_messages)
  end

  def convert_decision_branches!
    @bot.question_answer.find_each do |question_answer|
      if question_answer.underlayer.present?
        current_answer = question_answer.answer
        question_answer.underlayer.each_slice(2) do |decision_branch_body, answer_body|
          decision_branch = current_answer.decision_branches.find_or_initialize_by(body: decision_branch_body, bot_id: @bot.id)
          if answer_body.present?
            current_answer = @bot.answers.find_or_initialize_by(body: answer_body, bot_id: @bot.id)
            decision_branch.next_answer = current_answer
          end
          decision_branch.save!
        end
      end
    end
  end
end
