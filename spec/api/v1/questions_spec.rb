require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT': 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let(:file_1) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:file_2) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:questions) { create_list(:question, 3, files: [file_1, file_2], user: user) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let(:question) { questions.first }
    let!(:links) { create_list(:link, 3, linkable: question) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:method) { :get }
      let(:resource_responce) { json['question'] }
      let(:public_fields) { %w[id title body created_at updated_at] }
      let(:resource) { question }

      it_behaves_like 'Answer Question'
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let!(:question) { create :question, user: user }
    let!(:answers) { create_list(:answer, 3, user: user, question: question) }
    let(:answer) { answers.first }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status if there is access_token' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }

    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'Authenticated user' do
      context 'with valid attributes' do
        let(:params) do
          {
            user_id: user.id,
            title: 'Test question',
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

        it 'saves a new question in the database' do
          expect do
            post api_path, params: { question: params, access_token: access_token.token }, headers: headers
          end.to change(Question, :count).by(1)
        end

        it 'returns 200' do
          post api_path, params: { question: params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            user_id: user.id,
            title: '',
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

        it 'does not save the question' do
          expect do
            post api_path, params: { question: params, access_token: access_token.token }, headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PATH /api/v1/questions/:id' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let(:question) { create :question, user: user }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'Authenticated user' do
      context 'with valid attributes' do
        let(:params) do
          {
            user_id: user.id,
            title: 'new title',
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

        it 'changes question attributes' do
          patch api_path, params: { question: params, access_token: access_token.token }, headers: headers
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'returns 200' do
          patch api_path, params: { question: params, access_token: access_token.token }, headers: headers
          expect(response).to be_successful
        end

        context 'with invalid attributes' do
          let(:params) do
            {
              user_id: user.id,
              title: '',
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

          before { patch api_path, params: { question: params, access_token: access_token.token }, headers: headers }

          it 'does not change question' do
            question.reload
            expect(question.title).to eq question.title
            expect(question.body).to eq question.body
          end
        end
      end
    end

    context 'Unauthenticated user' do
      let(:other_user) { create :user }
      let(:params) do
        {
          user_id: other_user.id,
          title: 'new title',
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

      it 'deletes the question' do
        patch api_path, params: { question: params, access_token: access_token.token }, headers: headers
        expect(JSON.parse(response.body).first).to eq "You don't have permission to access on this server"
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let!(:question) { create :question, user: user }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'Authenticated user' do
      let(:params) do
        { user_id: user.id }
      end

      it 'deletes the question' do
        expect { delete api_path, params: { question: params, access_token: access_token.token }, headers: headers }.to change(Question, :count).by(-1)
      end
    end

    context 'Unauthenticated user' do
      let(:other_user) { create :user }
      let(:params) do
        { user_id: other_user.id }
      end

      it 'deletes the question' do
        delete api_path, params: { question: params, access_token: access_token.token }, headers: headers
        expect(JSON.parse(response.body).first).to eq "You don't have permission to access on this server"
      end
    end
  end
end
