require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }
  it { should have_many(:autorizations) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has autorization' do
      it 'returns the user' do
        user.autorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not autorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates autorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.autorizations, :count).by(1)
        end

        it 'creates autorization with provider and uid' do
          autorization = User.find_for_oauth(auth).autorizations.first

          expect(autorization.provider).to eq auth.provider
          expect(autorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills new email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates autorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.autorizations).to_not be_empty
        end

        it 'creates autorization with provider and uid' do
          autorization = User.find_for_oauth(auth).autorizations.first

          expect(autorization.provider).to eq auth.provider
          expect(autorization.uid).to eq auth.uid
        end
      end
    end
  end
end
