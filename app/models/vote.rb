class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validate :author_cant_vote
  
  enum click: { dislike: -1, like: 1 }

  private

  def author_cant_vote
    errors.add(:user, "Author can't vote") if user&.author_of?(votable)
  end
end
