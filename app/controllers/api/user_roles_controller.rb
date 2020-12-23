class Api::UserRolesController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    render json: "Not Authorised"
  end
  def index
    @roles = Role.all
    render json: @roles
  end
end
