require 'rails_helper'

RSpec.describe FilePolicy, type: :policy do
  let(:user) { create :user }
  let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  let(:file_parent) { create(:question, user: user, files: [file]) }

  subject { described_class }

  permissions :destroy? do
    it 'grants access if user present and user is author of file' do
      expect(subject).to permit(user, file_parent.files.first.record)
    end
  end
end
