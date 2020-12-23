class Api::UsersController < ApplicationController
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    render json: "Not Authorised"
  end
  def create
    @user = User.new(user_params)
    @user.user_roles.new(role_id: params[:user][:role_id])
    if @user.save
      render success: true
    else
      render json: @user.errors.full_messages 
    end
  end  
  private
    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj) 
    end
end