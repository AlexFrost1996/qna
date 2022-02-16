require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  context 'GET #new' do
    it 'render authorization new' do
      get :new
      expect(response).to render_template :new
    end
  end

  context 'POST #create' do
    before do
      allow(AuthorizationsMailer).to receive(:email_confirmation).and_return(Struct.new(:deliver_later).new)
    end

    context 'new user' do
      it 'creates new user' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: 'user@gmail.com' }
        end.to change(User, :count).by(1)
      end

      it 'creates unconfirmed authorization' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: 'user@gmail.com' }
        end.to change(Authorization, :count).by(1)

        authorization = Authorization.last
        expect(authorization.provider).to eq 'vkontakte'
        expect(authorization.uid).to eq '123'
        expect(authorization).not_to be_confirmed
      end

      it 'redirect to root path' do
        post :create, params: { uid: 123, provider: 'vkontakte', email: 'user@gmail.com' }
        expect(response).to redirect_to root_path
      end
    end

    context 'user exist' do
      let!(:user) { create :user }

      it 'does not create new user' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
        end.to_not change(User, :count)
      end

      it 'redirect to root path' do
        post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
        expect(response).to redirect_to root_path
      end

      context 'new authorization' do
        it 'creates unconfirmed authorization' do
          expect do
            post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
          end.to change(Authorization, :count).by(1)

          authorization = Authorization.last
          expect(authorization.provider).to eq 'vkontakte'
          expect(authorization.uid).to eq '123'
          expect(authorization).not_to be_confirmed
        end
      end

      context 'authorization exist' do
        let!(:authorization) { create(:authorization, user: user, provider: 'vkontakte', uid: '123') }

        it 'does not create authorization' do
          expect do
            post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
          end.to_not change(Authorization, :count)
        end
      end
    end

    context 'GET #email_confirmation' do
      let!(:user) { create :user }
      let!(:authorization) { create(:authorization, user: user, provider: 'vkontakte', uid: '123', confirmation_token: '131231ddsf') }

      before do
        get :email_confirmation, params: { confirmation_token: authorization.confirmation_token }
      end

      it 'confirms authorization' do
        authorization.reload
        expect(authorization).to be_confirmed
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
