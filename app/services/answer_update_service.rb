class AnswerUpdateService
  def initialize(bot, answer, params)
    @bot = bot
    @answer = answer
    @params = params
  end

  def process!
    if @answer.body != @params[:body]
      @old_answer = @answer
      @answer = @bot.answers.build(@params)
    else
      @answer.assign_attributes(@params)
    end

    @answer.save!

    if @old_answer.present?
      %w(answer_files decision_branches training_messages question_answers).each do |resources|
        @old_answer.send(resources).each do |resource|
          resource.update!(answer_id: @answer.id)
        end
      end

      if @old_answer.parent_decision_branch.present?
        @old_answer&.parent_decision_branch.update!(next_answer_id: @answer.id)
      end
    end

    @answer
  end
end
