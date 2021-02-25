class InventorySystem::AssetTracksController < ApplicationController
  def index
    render json: AssetTrack.all_asset_track
  end
end
