require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new subscribtion in the database' do
          expect do
            post :create,
                 params: { question_id: question },
                 format: :js
          end.to change(Subscriber, :count).by(1)
        end

        it 'has a valid question' do
          post :create, params: { question_id: question }, format: :js
          expect(assigns(:subscriber).question).to eq question
        end

        it 'has a valid user' do
          post :create, params: { question_id: question }, format: :js
          expect(assigns(:subscriber).user).to eq user
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save the subscribtion' do
        expect do
          post :create,
               params: { question_id: question },
               format: :js
        end.to_not change(Subscriber, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: { question_id: 100 }, format: :js
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscriber) { create :subscriber, user_id: user.id }

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'destroy subscribtion in the database' do
          expect do
            post :destroy,
                 params: { id: subscriber },
                 format: :js
          end.to change(Subscriber, :count).by(-1)
        end

        it 'returns success' do
          post :destroy, params: { id: subscriber }, format: :js
          expect(response).to be_successful
        end
      end
    end

    context "user can not delete other user's subscribtion" do
      let!(:other_user) { create :user }
      before { login(other_user) }

      it 'can not delete subscribtion' do
        expect do
          post :destroy, params: { id: subscriber }, format: :js
        end.to_not change(Subscriber, :count)
      end

      it 'returns 403 status' do
        post :destroy, params: { id: subscriber }, format: :js
        expect(response.status).to eq 403
      end
    end

    context 'unauthenticated user' do
      it 'does not delete the subscribtion' do
        expect do
          post :destroy,
               params: { id: subscriber },
               format: :js
        end.to_not change(Subscriber, :count)
      end

      it 'redirects to sign in page' do
        post :destroy, params: { id: subscriber }, format: :js
        expect(response).to be_unauthorized
      end
    end
  end
end
