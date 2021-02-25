class Api::SessionController < ApplicationController

  skip_load_and_authorize_resource
  
  def create
    @user = User.find_by(email: params[:email])
    (@user&.valid_password? (params[:password])) ? (render json: @user.as_json(only: [:email, :authentication_token, :id, :current_role, :f_name, :l_name])) : (render :json => {:message => "you have entered wrong credentials"})  
  end
  
  def destroy
    if current_user 
      current_user.authentication_token = nil 
      current_user.save
      render :json => {:message => "you have succesfully logged out"}
    else
      render :json => {:message => "you have succesfully logged out"}
    end    
  end
  
end