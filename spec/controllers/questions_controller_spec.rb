require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }
    it 'populates an array on all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list :answer, 3, question: question, user: user }

    before { get :show, params: { id: question } }

    it 'assigns the requested to question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'populates an array of @answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'Authenticated user' do
      before { login(user) }
      before { get :new }
  
      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question) 
      end
  
      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'Unauthenticated user' do
      before { get :new }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'Authenticated user' do
      before { login(user) }
      before { get :edit, params: { id: question, user: user } }
 
      it 'assigns the requested to question to @question' do
        expect(assigns(:question)).to eq question
      end
  
      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Unauthenticated user' do
      before { get :edit, params: { id: question, user: user } }

      it 'does not change the question' do
        expect(assigns(:question)).to_not eq question
      end

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question), user: user } 
                 }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question), user: user }
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end
  
      context 'without valid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid), user: user }
                 }.to_not change(Question, :count)
        end
  
        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid), user: user }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question), user: user }
               }.to_not change(Question, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { question: attributes_for(:question), user: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested to question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), user: user }
          expect(assigns(:question)).to eq question
        end
  
        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, user: user }
          question.reload
  
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end
  
        it 'redirects to updated question' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, user: user }
          expect(response).to redirect_to question
        end
      end
  
      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), user: user } }
        
        it 'does not change question' do
          question.reload
  
          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end
  
        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'Unauthenticated user' do
      it 'not changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, user: user }
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'redirect to sign in page' do
        patch :update, params: { id: question, question: attributes_for(:question), user: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context "user's question" do
        let!(:question) { create(:question, user: user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end
    
        it 'redirects to index' do
          expect { delete :destroy, params: { id: question } }
          redirect_to questions_path
        end
      end

      context 'other questions' do
        let!(:question) { create(:question, user: create(:user)) }

        it 'does not deletes the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end
    
        it 'redirects to root page' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:question) { create(:question, user: user) }

      it 'could not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
  
      it 'redirect to sign in page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
