require 'rails_helper'

RSpec.describe SubscriberPolicy, type: :policy do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:subscriber) { create :subscriber, question_id: question.id, user_id: user.id }

  subject { described_class }

  permissions :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, create(:subscriber))
    end
  end

  permissions :destroy? do
    it 'grants access if user present and user is author of subscriber' do
      expect(subject).to permit(user, subscriber)
    end

    it 'denies access if user is not author of subscriber' do
      expect(subject).to_not permit(User.new, subscriber)
    end
  end
end
