shared_examples 'voted controller' do
  let(:model_klass) { described_class.controller_name.singularize.underscore.to_sym }
  let!(:user) { create :user }
  let!(:author) { create :user }
  let!(:votable) { create(model_klass, user: author) }

  describe 'POST #up' do
    context 'Authenticated user' do
      before { login(user) }
      it 'likes' do
        post :like, params: { id: votable.id }, format: :json
        result = {
          votable_id: votable.id,
          rating: 1,
          model: votable.class.name.underscore,
          user_vote: 'like'
        }.as_json
        resp = JSON.parse(response.body)
        expect(resp).to eq result
      end

      it 'resets like' do
        post :like, params: { id: votable.id }, format: :json
        post :like, params: { id: votable.id }, format: :json
        result = {
          votable_id: votable.id,
          rating: 0,
          model: votable.class.name.underscore,
          user_vote: nil
        }.as_json
        resp = JSON.parse(response.body)
        expect(resp).to eq result
      end
    end

    context 'Vote for own votable' do
      before { login(author) }
      it 'can not vote' do
        post :like, params: { id: votable.id }, format: :json
        expect(response.status).to eq 403
      end
    end

    context 'Unauthenticated user' do
      it 'can not dislikes likes' do
        post :like, params: { id: votable.id }, format: :json
        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #down' do
    context 'Authenticated user' do
      before { login(user) }
      it 'dislikes' do
        post :dislike, params: { id: votable.id }, format: :json
        result = {
          votable_id: votable.id,
          rating: -1,
          model: votable.class.name.underscore,
          user_vote: 'dislike'
        }.as_json
        resp = JSON.parse(response.body)
        expect(resp).to eq result
      end

      it 'resets dislike' do
        post :dislike, params: { id: votable.id }, format: :json
        post :dislike, params: { id: votable.id }, format: :json
        result = {
          votable_id: votable.id,
          rating: 0,
          model: votable.class.name.underscore,
          user_vote: nil
        }.as_json
        resp = JSON.parse(response.body)
        expect(resp).to eq result
      end
    end

    context 'Vote for own votable' do
      before { login(author) }
      it 'can not vote' do
        post :like, params: { id: votable.id }, format: :json
        expect(response.status).to eq 403
      end
    end

    context 'Unauthenticated user' do
      it 'can not dislikes' do
        post :dislike, params: { id: votable.id }, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
