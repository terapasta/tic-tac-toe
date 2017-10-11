class TopicTaggingPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def create?
    staff_or_owner?
  end

  def destroy?
    staff_or_owner?
  end

  def permitted_attributes
    [
      :topic_tag_id,
    ]
  end

  private
    def target_bot
      record.question_answer.bot
    end
end
