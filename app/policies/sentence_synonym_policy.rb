class SentenceSynonymPolicy < ApplicationPolicy
  def index?
    user.staff? || user.normal? || user.worker?
  end

  def worker_filter?
    user.staff? || user.normal?
  end

  def show?
    user.staff? || user.normal? || record.created_user == user
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def update?
    user.present?
  end

  # TODO: current_user.normal? の時のみ
  #       record.training_message.bot.user_id == user.id をチェックしたい
  def destroy?
    user.normal? || user.staff?
  end
end
