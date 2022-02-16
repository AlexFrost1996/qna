require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    it_behaves_like 'provider OAuth' do
      let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', uid: 123) }
      let(:provider) { 'github' }
    end
  end

  describe 'Facebook' do
    it_behaves_like 'provider OAuth' do
      let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'facebook', uid: 123) }
      let(:provider) { 'facebook' }
    end
  end

  describe 'Twitter' do
    it_behaves_like 'provider OAuth' do
      let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'twitter', uid: 123) }
      let(:provider) { 'twitter' }
    end
  end

  describe 'Vkontakte' do
    it_behaves_like 'provider OAuth' do
      let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: 123) }
      let(:provider) { 'vkontakte' }
    end
  end
end
