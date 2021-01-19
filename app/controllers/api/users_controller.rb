class Api::UsersController < ApplicationController

  def index
    user_listing = User.excluding_admin
    render json: user_listing.as_json(only: [:f_name, :l_name, :current_role])
  end

  def create
    @user = User.new(user_params)
    @user.user_roles.new(role_id: user_role.id)
    @user.current_role = user_role.name
    @user.save ? (render json: @user) : (render json: @user.errors)
  end 

  def update
    if role_is_admin
      @user.current_role = user_role.name
      (@user.update(update_params)) ? (render json: @user) : (render json: @user.errors)
    elsif current_user.id == params[:id].to_i
      current_user.update(user_own_params)
      render json: current_user.as_json(only: [:f_name, :l_name, :dob])
    else
      render :json => {:message=> "You can not update"}
    end
  end

  def destroy
    @user.destroy
    render :json => {:message=> "User deleted"}
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]}) 
    end

    def update_params
      params.require(:user).permit(:f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]})
    end

    def user_own_params
      params.require(:user).permit(:password, :f_name, :l_name, :dob)
    end

    def user_role
      return Role.find_role(params[:user][:user_roles_attributes][0][:role_id].to_i)
    end
end
