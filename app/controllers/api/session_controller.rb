class Api::SessionController < ApplicationController

  skip_load_and_authorize_resource
  
  def create
    @user = User.find_by(email: params[:email])
    (@user&.valid_password? (params[:password])) ? (render json: @user.as_json(only: [:email, :authentication_token, :id, :current_role])) : (render json: "you have entered wrong credentials")  
  end
  
  def destroy
    current_user ? (current_user.authentication_token = nil; current_user.save; render json: "you have succesfully logged Out") : (render json: "first login")    
  end
end