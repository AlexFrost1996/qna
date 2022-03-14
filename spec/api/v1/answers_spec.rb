require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT': 'application/json' } }

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let(:file_1) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:file_2) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:question) { create :question, user: user }
    let!(:answer) { create :answer, question: question, user: user, files: [file_1, file_2] }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:method) { :get }
      let(:resource_responce) { json['answer'] }
      let(:public_fields) { %w[id body created_at updated_at] }
      let(:resource) { answer }

      it_behaves_like 'Answer Question'
    end
  end

  describe 'POST /api/v1/answers' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let(:question) { create :question, user: user }

    let(:api_path) { '/api/v1/answers' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'Authenticated user' do
      context 'with valid attributes' do
        let(:params) do
          {
            question_id: question.id,
            user_id: user.id,
            body: 'Question body',
            links_attributes: [
              {
                name: 'Google',
                url: 'https://google.com'
              },
              {
                name: 'Youtube',
                url: 'https://youtube.com'
              }
            ]
          }
        end

        it 'saves a new answer in the database' do
          expect do
            post api_path, params: { answer: params, access_token: access_token.token }, headers: headers
          end.to change(Answer, :count).by(1)
        end

        it 'returns 200' do
          post api_path, params: { answer: params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            question_id: question.id,
            user_id: user.id,
            body: '',
            links_attributes: [
              {
                name: 'Google',
                url: 'https://google.com'
              },
              {
                name: 'Youtube',
                url: 'https://youtube.com'
              }
            ]
          }
        end

        it 'does not save the answer' do
          expect do
            post api_path, params: { answer: params, access_token: access_token.token }, headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'PATH /api/v1/answers/:id' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, user: user, question: question }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'Authenticated user' do
      context 'with valid attributes' do
        let(:params) do
          {
            question_id: question.id,
            user_id: user.id,
            body: 'new body',
            links_attributes: [
              {
                name: 'Google',
                url: 'https://google.com'
              },
              {
                name: 'Youtube',
                url: 'https://youtube.com'
              }
            ]
          }
        end

        it 'changes answer attributes' do
          patch api_path, params: { answer: params, access_token: access_token.token }, headers: headers
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'returns 200' do
          patch api_path, params: { answer: params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        context 'with invalid attributes' do
          let(:params) do
            {
              question_id: question.id,
              user_id: user.id,
              body: '',
              links_attributes: [
                {
                  name: 'Google',
                  url: 'https://google.com'
                },
                {
                  name: 'Youtube',
                  url: 'https://youtube.com'
                }
              ]
            }
          end

          before { patch api_path, params: { answer: params, access_token: access_token.token }, headers: headers }

          it 'does not change answer' do
            answer.reload
            expect(answer.body).to eq answer.body
          end
        end
      end
    end

    context 'Unauthenticated user' do
      let(:other_user) { create :user }
      let(:params) do
        {
          question_id: question.id,
          user_id: other_user.id,
          body: 'new body',
          links_attributes: [
            {
              name: 'Google',
              url: 'https://google.com'
            },
            {
              name: 'Youtube',
              url: 'https://youtube.com'
            }
          ]
        }
      end

      it 'deletes the answer' do
        patch api_path, params: { answer: params, access_token: access_token.token }, headers: headers
        expect(JSON.parse(response.body).first).to eq "You don't have permission to access on this server"
      end
    end
  end

  describe 'DELETE /api/v1/answer/:id' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let(:question) { create :question, user: user }
    let!(:answer) { create :answer, user: user, question: question }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'Authenticated user' do
      let(:params) do
        { user_id: user.id }
      end

      it 'deletes the answer' do
        expect { delete api_path, params: { answer: params, access_token: access_token.token }, headers: headers }.to change(Answer, :count).by(-1)
      end
    end

    context 'Unauthenticated user' do
      let(:other_user) { create :user }
      let(:params) do
        { user_id: other_user.id }
      end

      it 'deletes the answer' do
        delete api_path, params: { answer: params, access_token: access_token.token }, headers: headers
        expect(JSON.parse(response.body).first).to eq "You don't have permission to access on this server"
      end
    end
  end
end
