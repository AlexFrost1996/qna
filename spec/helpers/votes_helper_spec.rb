require 'rails_helper'

RSpec.describe VotesHelper, type: :helper do
  describe '#vote' do
    let!(:user) { create(:user) }
    let!(:author) { create(:user) }
    let!(:votable) { create(:question, user: author) }
    let!(:vote) { create(:vote, user: user, votable: votable, click: 1) }

    it 'returns vote' do
      expect(helper.vote(user, votable)).to eq vote
    end
  end
end
