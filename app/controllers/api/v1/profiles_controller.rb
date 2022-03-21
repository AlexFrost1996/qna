class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize_resource
    render json: current_resource_owner
  end

  def all
    authorize_resource
    @profiles = User.where("id != #{current_resource_owner.id}")
    render json: @profiles, each_serializer: Api::V1::ProfileSerializer
  end

  private

  def authorize_resource
    @current_user = current_resource_owner
    authorize User, policy_class: ProfilePolicy
  end
end
