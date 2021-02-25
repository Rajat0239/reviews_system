class InventorySystem::AssetItemValuesController < ApplicationController

  def update
    @asset_item_value.update(value: params[:asset_item_value][:value]) ? (render :json => {:message => "asset item value updated succussfully"}) : (render json: @asset_item_value.errors.full_messages)
  end

  def destroy
    @asset_item_value.destroy ? (render :json => {:message => "asset item value deleted succussfully"}) : (render json: @asset_item_value.errors.full_messages)
  end
  
end