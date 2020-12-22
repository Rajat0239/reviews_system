class Api::UsersController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    render json: "Not Authorised"
  end
  def create
    @user = User.new(user_params)
    if @user.save
      @user_id = User.select(:id).find_by(email: params[:email])
      @roll_id = Role.select(:id).find_by(name: params[:role_name])
      byebug
      @updated = UserRole.new(role_id: @roll_id , user_id: @user_id)
    else
    end
  end  
  private
    def user_params
      params.permit(:email, :password, :f_name, :l_name, :dob, :doj) 
    end
end