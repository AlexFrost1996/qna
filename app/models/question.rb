class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, -> { order(best: :desc) }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscribers, dependent: :destroy
  has_one :award, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
