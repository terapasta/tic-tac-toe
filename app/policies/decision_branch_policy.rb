class DecisionBranchPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    staff_or_owner?
  end

  def new?
    create?
  end

  def create?
    staff_or_owner?
  end

  def edit?
    update?
  end

  def update?
    staff_or_owner?
  end

  def destroy?
    staff_or_owner?
  end

  def permitted_attributes
    [
      :body,
      :answer,
      :next_answer_id,
      :parent_decision_branch_id,
    ]
  end

  private
    def target_bot
      record.bot
    end
end
