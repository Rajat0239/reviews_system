class InventorySystem::AssetItemValuesController < ApplicationController

  def update
    @asset_item_value.update(value: params[:asset_item_value][:value]) ? success_response("asset item value updated succussfully") : faliure_response(@asset_item_value.errors.full_messages)
  end

  def destroy
    @asset_item_value.destroy ? success_response("asset item value deleted succussfully") : faliure_response(@asset_item_value.errors.full_messages)
  end
  
end