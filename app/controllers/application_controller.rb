class ApplicationController < ActionController::API

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    render :json => {:message => "This User Not Authorised !"}, status: 401
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :json => {:message => "record not found"}, status: 404
  end

  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end

  def current_quarter
    return ((Time.now.month - 1)/3+1).to_s+" "+(Time.now.year).to_s
  end

  def role_is_admin
    return current_user.current_role == "admin"
  end

  def role_is_manager
    return current_user.current_role == "manager"
  end

  def role_id
    role =  Role.find_by(name: current_user.current_role)
    return role.id
  end

  def success_response(message)
    render :json => {:message => message}, status: 200
  end

  def faliure_response(message)
    render :json => {:message => message}, status: 422
  end

end
