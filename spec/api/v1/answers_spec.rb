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
end
