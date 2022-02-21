class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, through: :answers
  has_many :comments
  has_many :authorizations, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github twitter vkontakte facebook]

  def author_of?(subject)
    self.id == subject.user_id
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def create_unconfirmed_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid, confirmation_token: Devise.friendly_token)
  end

  def auth_confirmed?(auth)
    auth && self.authorizations.find_by(uid: auth.uid, provider: auth.provider)&.confirmed?
  end

  def generate_password
    self.password = self.password_confirmation = Devise.friendly_token
    self
  end
end
