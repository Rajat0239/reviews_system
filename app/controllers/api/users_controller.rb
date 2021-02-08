class Api::UsersController < ApplicationController

  before_action :check_reporting_role , only: [:create, :update]

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
      user_info = User.joins(:roles).where("users.id = ? AND roles.name = ?",params[:id],current_role_of_user).select("users.f_name, roles.id") 
      render json: user_info.to_aparams[:review].values
    else
      render json: current_user.as_json(only: [:f_name,:l_name,:dob])
    end
  end

  def create
    @user = User.new(user_params)
    @user.current_role = user_role
    @user.save ? (render json: @user) : (render json: @user.errors)
  end 

  def update
    if role_is_admin
      @user.current_role = user_role
      (@user.update(update_params_when_admin)) ? (render json: @user) : (render json: @user.errors)
    elsif current_user.id == params[:id].to_i
      current_user.update(user_own_params)
      render json: current_user.as_json(only: [:f_name, :l_name, :dob])
    else
      render :json => {:message=> "You can not update"}
    end
  end

  def destroy
    @user.destroy
    render :json => {:message => "user has been deleted"}
  end

  def show_reviews_of_user
    @reviews = Question.joins(:reviews).where("reviews.question_id = questions.id AND reviews.user_id = ? AND reviews.quarter = ?",params[:id],current_quarter).select("questions.id, questions.question, reviews.answer")
    @ratings = User.find(params[:id]).ratings_of_user_for_himselves.find_by(quarter: current_quarter).ratings
    render json: @reviews.to_a.push({"ratings": @ratings})
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, :reporting_user_id, {user_roles_attributes: [:id, :role_id]}) 
    end

    def update_params_when_admin
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
      render json: "you are adding admin reporting role should be of admin" unless user_current_role == "admin" if user_role == "admin"
      render json: "you are adding manager reporting role should be of admin" unless user_current_role == "admin" if user_role == "manager"
      render json: "you are adding employee reporting role should be of manager or admin" unless user_current_role == "manager" || user_current_role == "admin" if user_role == "employee"
    end
end
