class Api::UserController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    if @user&.valid_password?(params[:password]) #@user && @user.valid_password?(params[:password])
      render json: @user.as_json(only: [:email, :authentication_token]), status: :created
    else
      render json: "wrong password"
    end   
  end
  def destroy
  current_user&.authentication_token = nil
    if current_user.save
      render json: "Logged Out" 
    end  
  end
end