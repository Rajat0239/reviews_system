class ApplicationController < ActionController::API
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    render json: "Not Authorised"
  end
  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end
  def review_status
    return current_user.reviews.pluck(:quarter).include? current_quarter
  end
  def current_quarter
    return ((Time.now.month - 1)/3+1).to_s+" "+(Time.now.year).to_s
  end
  def roles
    return current_user.roles.pluck(:name)
  end
end
 