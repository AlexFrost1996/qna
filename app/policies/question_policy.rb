class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.admin? || user.author_of?(record)
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || user.author_of?(record)
  end

  def best?
    user.author_of?(record)
  end
end
