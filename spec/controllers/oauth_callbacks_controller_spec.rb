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
      let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'facebook', uid: 123, info: {}) }
      let(:provider) { 'facebook' }
    end
  end

  describe 'Twitter' do
    let!(:provider) { 'twitter' }
    let!(:oauth_data) { OmniAuth::AuthHash.new(provider: 'twitter', uid: 123) }

    it_behaves_like 'provider OAuth'
    it_behaves_like 'not provided email'
  end

  describe 'Vkontakte' do
    let!(:oauth_data) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: 123, info: {}) }
    let!(:provider) { 'vkontakte' }

    it_behaves_like 'provider OAuth'
    it_behaves_like 'not provided email'
  end
end
