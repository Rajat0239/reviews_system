class ApplicationController < ActionController::API
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    render json: "Not Authorised"
  end
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: "Record Not Found"
  end

  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end

  def current_quarter
    return ((Time.now.month - 1)/3+1).to_s+" "+(Time.now.year).to_s
  end

  def is_quarter_present
    return ReviewDate.exists?(quarter: current_quarter)
  end

  def send_error_messages(field)
    field.errors.full_messages
  end
end
 