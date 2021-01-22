class Api::UsersController < ApplicationController

  before_action :check_reporting_role , only: [:create, :update]

  def index
    user_listing = User.excluding_admin
    render json: user_listing.as_json(only: [:id, :f_name, :l_name, :current_role])
  end

  def show
    @user = User.find(params[:id])
    render json: @user.as_json(except: [:authentication_token])
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
    render :json => {:message=> "user has been deleted"}
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
      return Role.find_role(params[:user][:user_roles_attributes][0][:role_id])
    end
    
    def check_reporting_role
      user_current_role = User.find_user_current_role(params[:user][:reporting_user_id])
      render json: "you are adding admin reporting role should be of admin" unless user_current_role == "admin" if user_role.name == "admin"
      render json: "you are adding manager reporting role should be of admin" unless user_current_role == "admin" if user_role.name == "manager"
      render json: "you are adding employee reporting role should be of manager or admin" unless user_current_role == "manager" || user_current_role == "admin" if user_role.name == "employee"
    end
end
