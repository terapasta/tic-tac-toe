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
    def target_bot
      record.word_mapping.bot
    end
end
