require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:service) { double('SearchService') }
  describe 'GET #search' do
    context 'with query' do
      it 'populates scope' do
        get :search, params: { query: 'test_query', scope: 'all' }
        expect(assigns(:scope)).to eq 'all'
      end

      it 'populates query' do
        get :search, params: { query: 'test_query', scope: 'all' }
        expect(assigns(:query)).to eq 'test_query'
      end

      it 'populates result' do
        expect(assigns(:result)).to_not be
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders search view' do
        get :search, params: { query: 'test_query', scope: 'all' }
        expect(response).to render_template 'search/_result'
      end

      it 'calls SearchService' do
        allow(SearchService).to receive(:new).and_return(service)
        expect(service).to receive(:call)
        get :search, params: { query: 'test_query', scope: 'all' }
      end
    end

    context 'without query' do
      before { get :search, params: { query: '', scope: 'all' } }

      it 'not populates result' do
        expect(assigns(:result)).to_not be
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders search view' do
        expect(response).to render_template 'search/_result'
      end

      it 'not calls SearchService' do
        allow(SearchService).to receive(:new).and_return(service)
        expect(service).to_not receive(:call)
        get :search, params: { query: '', scope: 'all' }
      end
    end
  end
end
