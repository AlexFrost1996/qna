class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:alert] = exception.message
        redirect_to root_path
      end
      format.json { render json: ["You don't have permission to access on this server"], status: :forbidden }
      format.js { render json: ["You don't have permission to access on this server"], status: :forbidden }
    end
  end
end
