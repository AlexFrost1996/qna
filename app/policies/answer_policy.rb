class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    user.present?
  end

  def update?
    user.admin? || user.author_of?(record)
  end

  def destroy?
    user.admin? || user.author_of?(record)
  end
end
