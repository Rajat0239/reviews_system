class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end
end
