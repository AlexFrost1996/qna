class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    authorize @link.linkable, policy_class: LinkPolicy
    @link.delete
  end
end
