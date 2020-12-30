class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.user_roles.new(role_id: params[:user][:role_id])
    @user.save ? (render success: true) : (render json: @user.errors.full_messages)
  end 
  def update
    @user = User.find_by(email: params[:user][:email])
    #current_user.roles.pluck(:name).include? "admin" ? ()
    #(current_user.roles.pluck(:name).include? "admin") ? 
    #byebug
    @user.update(user_params) ?  (render json: @user.roles) : (render json:"not authorised")
    #@user ? (@user.update(user_params); render json: @user) : (render json: "Not updated") 
  end
  private
    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, { user_roles_attributes:  [:id , :role_id] }) 
    end
end