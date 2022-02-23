require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:user) { create :user }
  let(:answer) { create :answer, user: user }
  let(:comment) { create :comment, commentable: answer }

  subject { described_class }

  permissions :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, comment.commentable)
    end
  end
end
