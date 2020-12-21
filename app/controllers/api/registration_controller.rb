class Api::RegistrationController < ApplicationController
  def create
    if User.find_by(authentication_token: params[:Authorization])
      
    else

    end
  end
end
