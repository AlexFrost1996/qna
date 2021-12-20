require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, user: user }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user } }.to change(question.answers, :count).by(1)
        end

        it 'redirects to question page' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), user_id: user } }.to_not change(question.answers, :count)
        end

        it 're-renders new view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), user_id: user }
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user } }.to_not change(question.answers, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), user_id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context "user's answer" do
        let!(:answer) { create(:answer, question: question, user: user) }
        
        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
        end

        it 'redirects to question' do
          delete :destroy, params: { id: answer, question_id: question }
          expect(response).to redirect_to question_path(assigns(:answer).question)
        end
      end

      context "others answers" do
        let!(:answer) { create(:answer, question: question, user: create(:user)) }

        it 'could not deletes the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
        end

        it 'redirects to question' do
          delete :destroy, params: { id: answer, question_id: question }
          expect(response).to redirect_to question_path(assigns(:answer).question)
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'could not deletes the answer' do
        expect { delete :destroy, params: { id: answer, user_id: user } }.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer, user_id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
