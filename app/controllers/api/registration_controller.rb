class Api: UserController < ApplicationController

  #load_and_authorize_resource
  def create
    byebug
    # @user = User.find_by(authentication_token: params[:Authorization]).roles.pluck:name
    # @user[0] == "admin"
    # byebug
  end
end
