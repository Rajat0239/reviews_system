class Api::UserController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    if @user&.valid_password?(params[:password]) 
      render json: @user.as_json(only: [:email]), status: :created
    else
      render json: "wrong password"
    end   
  end
  def destroy
    
  end
end
