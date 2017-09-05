class WordMappingPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def show?
    has_write_permission?
  end

  def new?
    create?
  end

  def create?
    has_write_permission?
  end

  def edit?
    update?
  end

  def update?
    has_write_permission?
  end

  def destroy?
    has_write_permission?
  end

  def permitted_attributes
    [
      :id,
      :word,
      :synonym,
      {
        word_mapping_synonyms_attributes: [
          :id,
          :value,
          :word_mapping_id,
          :_destroy
        ]
      }
    ]
  end

  private
    def has_write_permission?
      return true if record.bot_id.nil? && user.staff?
      user.normal? || user.staff?
    end
end
