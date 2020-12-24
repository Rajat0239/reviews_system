class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.user_roles.new(role_id: params[:user][:role_id])
    if @user.save
      render success: true
    else
      render json: @user.errors.full_messages 
    end
  end 
  def update
    @user = User.find_by(email: params[:user][:email])
    if @user
      @user.update(user_params)
      render json: @user
    else
      render json: "Not updated"
    end
  end 
  private
    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, { user_roles_attributes:  [:id , :role_id] }) 
    end
end