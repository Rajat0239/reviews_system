class Api::UsersController < ApplicationController

  before_action :check_reporting_role , only: [:create]

  def index
    if role_is_admin
      user_listing = User.excluding_admin
      render json: user_listing.as_json(only: [:id, :f_name, :l_name, :current_role])
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
    @user = User.new(user_params)
    @user.current_role = user_role
    @user.save ? (render json: @user) : (render json: @user.errors)
  end 

  def update
    if role_is_admin
      if Role.find(params[:id]).name == "admin"
        @user.update(update_admin) ? (render :json => {:message => "updated successfully"}) : (render json: @user.errors)
      else
        check_reporting_role
        @user.current_role = user_role
        @user.update(update_params_when_admin) ? (render :json => {:message => "updated successfully"}) : (render json: @user.errors)
      end
    elsif current_user.id == params[:id].to_i
      current_user.update(user_own_params) ? (render :json => {:message => "updated successfully"}) : (render :json => @current_user.errors)
    else
      render :json => {:message=> "You can not update"}
    end
  end

  def destroy
    @user.destroy
    render :json => {:message => "user has been removed"}
  end

  def show_reviews_of_user
    @reviews = Question.joins(:reviews).where("reviews.question_id = questions.id AND reviews.user_id = ? AND reviews.quarter = ?",params[:user_id],current_quarter).select(" questions.question, reviews.answer, reviews.id")
    unless @reviews.empty?
      @ratings = User.find(params[:user_id]).ratings.find_by(quarter: current_quarter).ratings_by_user
      render json: @reviews.to_a.push({"ratings": @ratings},{"user_id": params[:user_id]})
    else 
      render :json => {:message => "review is not available for this user"}
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]}) 
    end

    def update_params_when_admin
      params.require(:user).permit(:f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]})
    end

    def update_admin
      params.require(:user).permit(:password, :f_name, :l_name, :dob)
    end

    def user_own_params
      params.require(:user).permit(:password, :f_name, :l_name, :dob)
    end

    def user_role
      return Role.find_role(params[:user][:user_roles_attributes][1][:role_id])
    end
    
    def check_reporting_role
      user_current_role = User.find_user_current_role(params[:user][:reporting_user_id])
      render json: "you are adding admin reporting role should be of admin" unless user_current_role == "admin" if user_role == "admin"
      render json: "you are adding manager reporting role should be of admin" unless user_current_role == "admin" if user_role == "manager"
      render json: "you are adding employee reporting role should be of manager or admin" unless user_current_role == "manager" || user_current_role == "admin" if user_role == "employee"
    end

    def user_data_for_admin
      role = Role.find_by(name: @user.current_role).id
      @user.as_json(only:[:id,:email,:f_name,:l_name,:dob,:doj,:reporting_user_id]).merge("role" => role)
    end
end
