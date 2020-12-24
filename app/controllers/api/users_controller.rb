class Api::UsersController < ApplicationController
  def index
    @user = User.find(5).roles.pluck:name
    if @user.include? "manager"
      render json: true
    else
      render json: false
    end
  end
  def create
    @user = User.new(user_params)
    @user.user_roles.new(role_id: params[:user][:role_id])
    if @user.save
      render success: true
    else
      render json: @user.errors.full_messages 
    end
  end 
  def update
    #byebug
    @user = User.find_by(email: params[:user][:email])
    #@roles = @user.roles.pluck:id
    # if @roles.include? params[:user][:user_roles_attributes][:role_id].to_i
    #   render json: "Already there"
    # else
    #   @user.update(user_params)
    #   render json: @user.roles
    # end
    @user.update(user_params)
    render json: @user.roles
  end 
  private
    def user_params
      params.require(:user).permit(:email, :password, :f_name, :l_name, :dob, :doj, { user_roles_attributes:  [:id , :role_id] }) 
    end
end