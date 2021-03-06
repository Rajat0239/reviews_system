class Users::UsersController < ApplicationController
  def index
    if role_is_admin
      user_listing = User.excluding_admin
      user_listing.present? ? (render json: user_listing.as_json(only: %i[id f_name l_name current_role active_status])) : (render json: { message: 'Sorry! Users is not available !' })
    else
      current_user.current_role == 'manager'
      employee_under_manager = User.employee_under_manager(current_user.id)
      employee_under_manager.present? ? (render json: employee_under_manager.as_json(only: %i[id email f_name l_name])) : (render json: { message: 'Sorry! Users is not available !' })
    end
  end

  def show
    if role_is_admin
      render json: user_data_for_admin
    else
      render json: current_user.as_json(only: %i[email f_name l_name dob])
    end
  end

  def create
    if check_reporting_role
      @user = User.new(user_params)
      @user.current_role = user_role
      @user.save ? (render json: { message: @user }) : (render json: { message: @user.errors.messages })
    else
      render json: { message: 'reporting role is invalid' }
    end
  end

  def update
    if role_is_admin
      admin_updation_part
    elsif current_user.id == params[:id].to_i
      current_user.update(user_own_params) ? (render json: { message: 'updated successfully' }) : (render json: @current_user.errors)
    else
      render json: { message: 'You can not update' }
    end
  end

  def destroy
    if @user.update(active_status: false)
      update_users_reporting_user(@user) if @user.current_role == 'manager'
      render json: { message: 'user has been disabled' }
    else
      render json: { message: @user.errors.messages.first}
    end
  end

  def user_inventory_list
    @user
  end

  def user_list_for_allocation
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, :reporting_user_id,
                                 { user_roles_attributes: %i[id role_id] })
  end

  def update_params_when_admin
    params.require(:user).permit(:f_name, :l_name, :dob, :doj, :reporting_user_id,
                                 { user_roles_attributes: %i[id role_id] })
  end

  def update_admin_params
    params.require(:user).permit(:password, :f_name, :l_name, :dob)
  end

  def user_own_params
    params.require(:user).permit(:password, :f_name, :l_name, :dob)
  end

  def user_role
    Role.find_role(params[:user][:user_roles_attributes][0][:role_id])
  end

  def check_reporting_role
    user_current_role = User.find_user_current_role(params[:user][:reporting_user_id])
    @status = true
    @status = false if user_role == 'admin' && !(user_current_role == 'admin')
    @status = false if user_role == 'manager' && !(user_current_role == 'admin')
    @status = false if user_role == 'employee' && !%w[manager admin].include?(user_current_role)
    @status
  end

  def user_data_for_admin
    role = Role.find_by(name: @user.current_role).id
    user_role_id = UserRole.find_by(role_id: role, user_id: @user.id).id
    @user.as_json(only: %i[id email f_name l_name dob doj reporting_user_id]).merge('role' => role,
                                                                                    'user_role_id' => user_role_id)
  end

  def admin_updation_part
    if User.find(params[:id]).current_role == 'admin'
      @user.update(update_admin_params) ? (render json: { message: 'updated successfully' }) : (render json: @user.errors)
    else
      unless check_reporting_role
        render json: { message: 'reporting role is invalid' }
        return
      end
      @user_current_role = @user.current_role
      @user.current_role = user_role
      if @user.update(update_params_when_admin)
        update_users_reporting_user(@user) if @user_current_role == 'manager' && user_role == 'employee'
        render json: { message: 'updated successfully' }
      else
        render json: @user.errors
      end
    end
  end

  def update_users_reporting_user(user)
    @admin_id = Role.find_by(name: 'admin').id
    User.where(reporting_user_id: user.id).update_all(reporting_user_id: @admin_id)
  end
end
