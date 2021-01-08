class Api::UsersController < ApplicationController
  def create
    reporting_role_is_manager ? (
    @user = User.new(user_params);
    @user.user_roles.new(role_id: params[:role_id]);
    @user.current_role = Role.find_role(params[:role_id]);
    @user.save ? (render json: @user) : (render json: @user.errors.full_messages)) : (render json: "Please select reporting user id of manager")
  end 

  def update
    if ((roles.include? "admin") && @user = User.find_user(params[:id])) && reporting_role_is_manager
      @user.current_role = Role.find_role(params[:user_roles_attributes]['0'][:role_id].to_i)
      (@user.update(update_params)) ? (render json: @user) : (render json: @user.errors.full_messages)
    elsif current_user.id == params[:id].to_i 
      current_user.update(params.require(:user).permit(:password, :f_name, :l_name, :dob))
      render json: current_user.roles
    else
      render json: "You can not update"
    end
  end

  def destroy
    @user.destroy
    render json: "User inside the data destroyed"
  end

  private
    def user_params
      params.permit(:email, :password, :f_name, :l_name, :dob, :doj , :reporting_user_id) 
    end

    def update_params
      params.permit(:f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]})
    end

    def reporting_role_is_manager
      return (@user = User.find_user(params[:reporting_user_id]).current_role.include? "manager")
    end
end