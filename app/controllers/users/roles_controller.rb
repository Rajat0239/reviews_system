class Users::RolesController < ApplicationController
  def index
    @roles = Role.all
    render json: @roles
  end

  def create
    @role = Role.new(name: params[:user_roles][:name])
    @role.save ? (render json: { message: 'Role Create successfully' }) : (render json: @role.errors)
  end

  def update
    @role = Role.find(params[:id])
    @role.update(name: params[:user_roles][:name]) ? (render json: { message: 'Role update successfully' }) : (render json: @role.errors)
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy ? (render json: { message: 'Role deleted successfully' }) : (render json: @role.errors)
  end

  private

  def user_params
    params.require(:user_roles).permit(:name)
  end
end

