shared_examples 'not provided email' do
  context 'without authorization' do
    let!(:user) { create(:user) }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    it 'redirect to email confirmation' do
      get provider
      expect(response).to redirect_to new_authorization_path(uid: oauth_data.uid, provider: oauth_data.provider)
    end

    it 'does not login user' do
      expect(subject.current_user).to be_nil
    end
  end

  context 'with unconfirmed email' do
    let!(:user) { create(:user) }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      user.create_unconfirmed_authorization(oauth_data)
      get provider
    end

    it 'redirect to email confirmation path' do
      expect(response).to redirect_to new_authorization_path(uid: oauth_data.uid, provider: oauth_data.provider)
    end

    it 'not login user' do
      expect(subject.current_user).to be_nil
    end
  end
end
