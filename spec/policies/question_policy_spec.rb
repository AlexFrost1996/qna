require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create :user }
  let(:admin) { create :user, admin: true }

  subject { described_class }

  permissions :index?, :show? do
    it 'grants access if user present' do
      expect(subject).to permit(nil, create(:question))
    end
  end

  permissions :new?, :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, create(:question))
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, create(:question))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:question, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:question, user: user))
    end
  end

  permissions :best? do
    let(:admin_question) { create :question, user: admin }
    let(:admin_answer) { create :answer, question: admin_question, user: admin }

    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: user }

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, admin_question)
    end

    it 'grants access if user is author of question' do
      expect(subject).to permit(user, question)
    end

    it 'denies access if user is not author of question' do
      expect(subject).not_to permit(admin, question)
    end
  end
end
