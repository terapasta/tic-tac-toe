class QuestionAnswerPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def show?
    update?
  end

  def new?
    create?
  end

  def create?
    user.normal? || user.staff?
  end

  def edit?
    update?
  end

  def update?
    user.normal? || user.staff?
  end

  def destroy?
    user.normal? || user.staff?
  end

  def permitted_attributes
    [
      :id,
      {
        sentence_synonyms_attributes: [
          :body,
          :created_user_id
        ]
      }
    ]
  end
end
