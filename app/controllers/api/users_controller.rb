class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.user_roles.new(role_id: params[:user][:role_id])
    @user.save ? (render json: @user) : (render json: @user.errors.full_messages)
  end 
  def update
     if ((current_user.roles.pluck(:name).include? "admin") && @user = User.find(params[:id])) 
      @user.update(params.require(:user).permit(:f_name, :l_name, :dob, :doj, {user_roles_attributes: [:id, :role_id]}))
      render json: @user.roles
     elsif current_user.id == params[:id].to_i
      current_user.update(params.require(:user).permit(:password, :f_name, :l_name, :dob))
      render json: current_user.roles
     else
      render json: "you can not update"
     end
  end
  private
    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, { user_roles_attributes:  [:id , :role_id] }) 
    end
end