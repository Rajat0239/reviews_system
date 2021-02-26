class ReviewSystem::SessionController < ApplicationController
  
  skip_load_and_authorize_resource
  
  def create
    @user = User.find_by(email: params[:email])
    if @user&.valid_password? (params[:password])
      if_an_active_employee
    else
      render :json => {:message => "you have entered wrong credentials"}
    end
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
  
  def if_an_active_employee
    if @user.active_status
      render json: @user.as_json(only: [:email, :authentication_token, :id, :current_role, :f_name, :l_name])
    else
      render :json => {:message => "not an active employee"}
    end
  end
end