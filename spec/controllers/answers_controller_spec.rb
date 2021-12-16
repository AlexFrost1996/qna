require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, user: user }


  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested to answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'Authenticated user' do
      before { login(user) }
      before { get :new, params: { question_id: question } }

      it 'assigns a new Answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer) 
      end
  
      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      before { get :new, params: { question_id: question } }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'Authenticated user' do
      before { login(user) }
      before { get :edit, params: { id: answer } }
  
      it 'assigns the requested to answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end
  
      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Unauthenticated user' do
      before { get :edit, params: { id: answer } }
  
      it 'does not change the answer' do
        expect(assigns(:answer)).to_not eq answer
      end
  
      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: { body: "body" }, user: user }
                 }.to change(question.answers, :count).by(1)
        end
  
        it 'redirects to show view' do
          post :create, params: { question_id: question, answer: { body: "body" }, user: user }
          expect(response).to redirect_to assigns(:answer)
        end
      end
  
      context "with invalid attributes" do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), user: user }
                 }.to_not change(question.answers, :count)
        end
  
        it 're-renders new view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), user: user }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not saves the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), user: user }
               }.to_not change(question.answers, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), user: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested to answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), user: user }
          expect(assigns(:answer)).to eq answer
        end
  
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, user: user }
          answer.reload
  
          expect(answer.body).to eq 'new body'
        end
  
        it 'redirects to updated answer' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, user: user }
          expect(response).to redirect_to answer
        end
      end
  
      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), user: user } }
        
        it 'does not changes answer' do
          answer.reload
  
          expect(answer.body).to eq 'MyString'
        end
  
        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not updates the answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, user: user }
        answer.reload

        expect(answer.body).to eq answer.body
      end

      it 'redirect to sign in page' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, user: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context "user's answer" do
        let!(:answer) { create :answer, user: user }
  
        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
        end
    
        it 'redirects to question' do
          expect { delete :destroy, params: { id: answer } }
          redirect_to question_path(answer.question)
        end
      end

      context 'other answer' do
        let!(:answer) { create :answer, user: create(:user) }

        it 'does not deletes the answer' do
          expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        end
    
        it 'redirects to question' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(assigns(:answer).question)
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create :answer, user: user }

      it 'does not deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
