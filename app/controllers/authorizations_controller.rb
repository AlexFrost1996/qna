class AuthorizationsController < ApplicationController
  before_action :find_user, only: %i[create]

  def new
    @user = User.new
  end

  def create
    @user.generate_password.save! unless @user.persisted?
    authorization = Authorization.find_by(provider: auth_params['provider'], uid: auth_params['uid'])

    authorization ||= @user.create_unconfirmed_authorization(OmniAuth::AuthHash.new(auth_params))

    AuthorizationsMailer.email_confirmation(authorization).deliver_later
    redirect_to root_path, notice: 'Confirm your email by link on your email.'
  end

  def email_confirmation
    authorization = Authorization.find_by(confirmation_token: params[:confirmation_token])
    if authorization
      authorization.confirm!
      sign_in authorization.user
      flash[:notice] = 'Your email address has been successfully confirmed.'
    end
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find_or_initialize_by(email: auth_params[:email])
  end

  def auth_params
    params.permit(:email, :uid, :provider)
  end
end
