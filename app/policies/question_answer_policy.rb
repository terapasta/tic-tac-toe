class QuestionAnswerPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
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
        :answer,
        :answer_id,
        {
          sentence_synonyms_attributes: [
            :body,
            :created_user_id
          ],
          answer_attributes: [
            :id,
            :body,
            answer_files_attributes: [
              :id,
              :file,
              :_destroy
            ]
          ],
          topic_taggings_attributes: [
            :id,
            :topic_tag_id,
            :_destroy
          ]
        }
      ]
    end
  end

  private
    def staff_or_owner?
      return true if user.staff?
      user.normal? && record.bot.user == user
    end
end
