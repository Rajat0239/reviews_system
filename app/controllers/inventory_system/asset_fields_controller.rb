class InventorySystem::AssetFieldsController < ApplicationController

  def update
    @asset_field.update(field: params[:asset_field][:field]) ? (render :json => {:message => "asset field updated succussfully"}) : (render json: @asset_field.errors.full_messages)
  end

  def destroy
    @asset_field.destroy ? (render :json => {:message => "asset field deleted succussfully"}) : (render json: @asset_field.errors.full_messages)
  end

end