class ApplicationController < ActionController::API
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    render json: "Not Authorised"
  end
  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end
end
