class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :redirect_to_new_authorization, only: %i[twitter vkontakte]

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env['omniauth.auth'])

        if @user&.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          redirect_to root_path, alert: 'Something went wrong'
        end
      end
    }
  end

  %i[github twitter facebook vkontakte].each do |provider|
    provides_callback_for provider
  end

  private

  def redirect_to_new_authorization
    auth = request.env['omniauth.auth']
    user = User.find_for_oauth(auth)

    if auth&.uid && !user&.auth_confirmed?(auth)
      redirect_to new_authorization_path(uid: auth.uid, provider: auth.provider)
    end
  end
end
