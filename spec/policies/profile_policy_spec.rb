require 'rails_helper'

RSpec.describe ProfilePolicy, type: :policy do
  let(:user) { create :user, admin: true }
  let(:other_user) { create :user }

  subject { described_class }

  permissions :me? do
    it 'grants access if user present' do
      expect(subject).to permit(user, user)
    end
  end

  permissions :all? do
    it 'grants access if user is admin' do
      expect(subject).to permit(user, user)
    end

    it 'denies access if user is not admin' do
      expect(subject).to_not permit(other_user, user)
    end
  end
end
