class InventorySystem::AssetRequestsController < ApplicationController
  def index
    render json: AssetRequest.joins(:user).joins(:asset).where(status: false).select("asset_requests.id, users.id as user_id, assets.id as asset_id, users.f_name,users.l_name, assets.name, asset_requests.reason")
  end

  def update
    if @asset_request.update(status: true)
      success_response('request declined')
    else
      failure_response
    end
  end
end
