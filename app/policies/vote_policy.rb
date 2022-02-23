class VotePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def vote?
    user.present? && !user.author_of?(record)
  end

  def cancel_vote?
    user.author_of?(record)
  end
end
