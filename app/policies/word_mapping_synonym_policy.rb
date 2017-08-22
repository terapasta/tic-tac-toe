class WordMappingSynonymPolicy < ApplicationPolicy
  def create?
    staff_or_owner?
  end

  def update?
    staff_or_owner?
  end

  def destroy?
    staff_or_owner?
  end

  def permitted_attributes
    [
      :value,
    ]
  end

  private
    def staff_or_owner?
      return true if user.staff?
      record.word_mapping.bot.user == user
    end
end
