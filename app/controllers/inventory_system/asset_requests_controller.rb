class InventorySystem::AssetRequestsController < ApplicationController
  def index
    render json: AssetRequest.where(status: false)
  end
end
