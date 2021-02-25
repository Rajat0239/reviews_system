class Api::UsersController < ApplicationController

  def index
    if role_is_admin
      user_listing = User.excluding_admin
      render json: user_listing.as_json(only: [:id, :f_name, :l_name, :current_role, :active_status])
    else current_user.current_role == "manager"
      employee_under_manager = User.employee_under_manager(current_user.id)
      render json: employee_under_manager.as_json(only: [:id, :email, :f_name, :l_name])
    end
  end

  def show
    if role_is_admin
      render json: user_data_for_admin
    else
      render json: current_user.as_json(only: [:email,:f_name,:l_name,:dob,:doj])
    end
  end

  def create
    if check_reporting_role
      @user = User.new(user_params)
      @user.current_role = user_role
      @user.save ? (render json: @user) : (render json: @user.errors)
    else
      render :json => {:message => "reporting role is invalid"}
    end
  end 

  def update
    if role_is_admin
      admin_updation_part
    elsif current_user.id == params[:id].to_i
      current_user.update(user_own_params) ? (render :json => {:message => "updated successfully"}) : (render :json => @current_user.errors)
    else
      render :json => {:message=> "You can not update"}
    end
  end

  def destroy
    @user.update(active_status: false)
    update_users_reporting_user(@user) if @user.current_role == "manager"
    render :json => {:message => "user has been disabled"}
  end

  def show_reviews_of_user
    @reviews = QuestionForUser.joins("LEFT JOIN questions ON questions.id = question_for_users.question_id LEFT JOIN reviews on reviews.question_for_user_id = question_for_users.id").where("reviews.user_id = ? AND reviews.quarter = ? And question_for_users.status = ? ",params[:user_id],current_quarter,true).select("question_for_users.id, question_for_users.question_id,questions.question, reviews.answer, reviews.id")   
    unless @reviews.empty?
      @ratings = User.find(params[:user_id]).ratings.find_by(quarter: current_quarter).ratings_by_user
      render json: @reviews.to_a.push({"ratings": @ratings},{"user_id": params[:user_id]})
    else 
      render :json => {:message => "review is not available for this user"}
    end
  end

  def asset_items_of_user 
    render json: @user.asset_items.joins(:asset).select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as asset_name") 
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]}) 
    end

    def update_params_when_admin
      params.require(:user).permit(:f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]})
    end

    def update_admin_params
      params.require(:user).permit(:password, :f_name, :l_name, :dob)
    end

    def user_own_params
      params.require(:user).permit(:password, :f_name, :l_name, :dob)
    end

    def user_role
      return Role.find_role(params[:user][:user_roles_attributes][0][:role_id])
    end

    def check_reporting_role
      user_current_role = User.find_user_current_role(params[:user][:reporting_user_id])
      @status = true
      @status = false unless user_current_role == "admin" if user_role == "admin"
      @status = false unless user_current_role == "admin" if user_role == "manager"
      @status = false unless user_current_role == "manager" || user_current_role == "admin" if user_role == "employee"
      return @status
    end

    def user_data_for_admin
      role = Role.find_by(name: @user.current_role).id
      @user.as_json(only:[:id,:email,:f_name,:l_name,:dob,:doj,:reporting_user_id]).merge("role" => role)
    end

    def admin_updation_part
      if Role.find(params[:id]).name == "admin"
        @user.update(update_admin_params) ? (render :json => {:message => "updated successfully"}) : (render json: @user.errors)
      else
        unless check_reporting_role
          render :json => {:message => "reporting role is invalid"}
          return
        end
        @user_current_role = @user.current_role
        @user.current_role = user_role
        if @user.update(update_params_when_admin)
          update_users_reporting_user(@user) if @user_current_role == "manager" && user_role == "employee"
          render :json => {:message => "updated successfully"}
        else
          render json: @user.errors
        end
      end
    end  
    
    def update_users_reporting_user(user)
      @admin_id = Role.find_by(name: "admin").id
      User.where(reporting_user_id: user.id).update_all(reporting_user_id: @admin_id)
    end
end
