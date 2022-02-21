require "rails_helper"

RSpec.describe AuthorizationsMailer, type: :mailer do
  let!(:user) { create :user }
  let!(:authorization) { create(:authorization, user: user, provider: 'vkontakte', uid: '123', confirmation_token: '131231ddsf') }

  describe '#email_confirmation' do
    it "creates message to user's email" do
      message = AuthorizationsMailer.email_confirmation(authorization)

      expect(message.to).to be_include(authorization.user.email)
    end
  end
end
