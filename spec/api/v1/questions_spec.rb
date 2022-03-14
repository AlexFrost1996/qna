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
end
