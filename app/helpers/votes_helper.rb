module VotesHelper
  def vote(user, votable)
    Vote.find_by(user: user, votable: votable)
  end
end
