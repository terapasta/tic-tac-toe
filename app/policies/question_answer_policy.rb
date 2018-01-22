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

  def attachable_answer_file?(bot)
    !user.ec_plan?(bot)
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
          answer_files_attributes: [
            :id,
            :file,
            :_destroy
          ],
          topic_taggings_attributes: [
            :id,
            :topic_tag_id,
            :_destroy
          ],
          sub_questions_attributes: [
            :id,
            :question,
            :_destroy
          ]
        }
      ]
    end
  end

  private
    def target_bot
      record.bot
    end
end
