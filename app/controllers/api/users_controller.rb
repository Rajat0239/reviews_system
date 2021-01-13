class Api::UsersController < ApplicationController
  def create
    reporting_role_is_manager ? (
    @user = User.new(user_params);
    @user.current_role = Role.find_role(params[:user][:role_id])
    @user.user_roles.new(role_id: params[:user][:role_id]);
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
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, :reporting_user_id) 
    end

    def update_params
      params.permit(:f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]})
    end

    def reporting_role_is_manager
      return (User.find_user(params[:user][:reporting_user_id]).current_role.include? "manager")
    end
end




# class Api::UsersController < ApplicationController
#   before_action :is_reporting_role_manager, except: :destroy
#   def create
#     # @user = User.new(user_params)
#     # @user.user_roles.new(role_id: role.id)
#     # @user.current_role = role.name
#     # @user.save ? (render json: @user) : (render json: send_error_messages)
#     user_params
#     byebug
#   end
#   def update
#     if role_is_admin
#       @user.current_role = role.name
#       (@user.update(update_params)) ? (render json: @user) : (render json: send_error_messages)
#     elsif current_user.id == params[:id].to_i
#       current_user.update(param)
#       render json: current_user.as_json(only: [:f_name, :l_name, :dob])
#     else
#       render json: "You can not update"
#     end
#   end
#   def destroy
#     @user.destroy
#     render json: "user is deleted"
#   end
#   private
#     def user_params
#       #params = params.require(:user).permit(:email, :password).merge(update_params)
#     end
#     def update_params
#       params.require(:user).permit(:f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]})
#     end
#     def user_own_params
#       params.require(:user).permit(:password, :f_name, :l_name, :dob)
#     end
#     def is_reporting_role_manager
#       if !(User.find_user(params[:user][:reporting_user_id]).current_role == "manager")
#         render json: "reporting user role is not a manager"
#       end
#     end
#     def role
#       return Role.find_role(params[:user][:user_roles_attributes]['0'][:role_id].to_i)
#     end
#     def role_is_admin
#       return (current_user.roles.pluck(:name).include? "admin")
#     end
#     def send_error_messages
#       @user.errors.full_messages
#     end
# end