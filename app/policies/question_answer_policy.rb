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

  def autocomplete_answer_body?
    user.normal? || user.staff?
  end

  def permitted_attributes
    if user.worker?
      [
        :id,
        {
          sentence_synonyms_attributes: [
            :body,
            :created_user_id
          ]
        }
      ]
    else
      [
        :id,
        :question,
        :answer_id,
        {
          sentence_synonyms_attributes: [
            :body,
            :created_user_id
          ],
          answer_attributes: [
            :id,
            :body,
          ],
          topic_taggings_attributes: [
            :id,
            :topic_tag_id,
          ]
        }
      ]
    end
  end
end
