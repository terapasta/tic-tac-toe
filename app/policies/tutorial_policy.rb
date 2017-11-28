class TutorialPolicy < ApplicationPolicy
  def permitted_attributes
    Tutorial.tasks
  end
end