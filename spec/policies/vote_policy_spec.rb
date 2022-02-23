require 'rails_helper'

RSpec.describe VotePolicy, type: :policy do
  let(:user) { create :user }
  let(:other_user) { create :user }

  let(:votable) { create :question, user: user }
  let(:other_votable) { create :question, user: other_user }

  let(:vote) { create :vote, user: user, votable: other_votable }

  subject { described_class }

  permissions :vote? do
    it 'grants access if user present and user is author of votable' do
      expect(subject).to permit(User.new, votable)
    end

    it 'denies access if user is not author of voteable' do
      expect(subject).not_to permit(user, votable)
    end
  end

  permissions :cancel_vote? do
    it 'grants access if user is author of vote' do
      expect(subject).to permit(user, vote)
    end

    it 'denies access if user is not author of vote' do
      expect(subject).not_to permit(User.new, vote)
    end
  end
end
