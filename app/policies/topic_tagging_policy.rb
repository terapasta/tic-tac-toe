class TopicTaggingPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def create?
    has_owner_permission?
  end

  def destroy?
    has_owner_permission?
  end

  def permitted_attributes
    [
      :topic_tag_id,
    ]
  end

  private
    def has_owner_permission?
      return true if user.staff?
      user.normal? && record.question_answer.bot.user.id == user.id
    end
end
