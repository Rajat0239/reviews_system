class InventorySystem::AssetTracksController < ApplicationController

  def index
    @asset_tracks = AssetTrack.all
  end

end
