require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create :user }
  let(:admin) { create :user, admin: true }

  subject { described_class }

  permissions :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, create(:answer))
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, create(:answer))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:answer, user: user))
    end
  end
end
