class Admin::Bots::WordMappingPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def show?
    user.normal? || user.staff?
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
end
