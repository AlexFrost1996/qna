require 'rails_helper'

RSpec.describe AwardsController, type: :controller do 
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }
  let(:award) { create(:award, user_id: user.id) }

  describe 'GET #index' do
    context 'authenticated user' do
      before do 
        login(user)
        get :index
      end

      it 'populates an array of all awards' do
        expect(assigns(:awards)).to match_array(user.awards)  
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'unauthenticated user' do
      before { get :index }

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
