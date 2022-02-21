class OauthCallbacksController < Devise::OmniauthCallbacksController
  PROVIDERS = %i[github twitter facebook vkontakte]
  
  before_action :find_user, only: PROVIDERS
  before_action :redirect_to_new_authorization, only: %i[twitter vkontakte]

  PROVIDERS.each do |provider|
    define_method("#{provider}") do
      provides_callback_for(provider)
    end
  end

  private

  def find_user
    @auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(@auth)
  end

  def redirect_to_new_authorization
    if @auth&.uid && !@user&.auth_confirmed?(@auth)
      redirect_to new_authorization_path(uid: @auth.uid, provider: @auth.provider)
    end
  end

  def provides_callback_for(provider)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
