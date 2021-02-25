class InventorySystem::AssetItemsController < ApplicationController

  before_action :filer_fields_and_values, only: [:create]
  before_action :check_user_must_present, only: [:allocation_of_assets]

  def index
    render json: Asset.all_asset_items
  end

  def show
    render json: {asset_item: {id: @asset_item.id, asset_id: @asset_item.asset_id, name: (@asset_item.asset.name + " " + @asset_item.asset_count.to_s)}, asset_item_field_and_values: show_asset_item_fields_and_values}
  end

  def create
    @asset = Asset.find(params[:asset_item_data][:asset_id])
    @asset_item = @asset.asset_items.new(asset_item_params)
    @asset_item.save ? (render :json => {:message => "asset item added succussfully"}) : (render json: @asset_item.errors.full_messages)
  end

  def update
    @asset_item.update(asset_item_params) ? (render :json => {:message => "asset item updated succussfully"}) : (render json: @asset_item.errors.full_messages)
  end

  def destroy
    @asset_item.destroy ? (render :json => {:message => "asset item deleted succussfully"}) : (render json: @asset_item.errors.full_messages)
  end

  def allocation_of_assets
    unless check_asset_is_allocated_or_not?
      @asset_item.update(user_id: params[:user_id]) ? (render :json => {:message => "asset item allocated successfully"}) : (render json: @asset_item.errors.full_messages)
    else
      render :json => {:message => "the asset is already allocated to the user"}
    end
  end
  
  def deallocation_of_assets
    if check_asset_is_allocated_or_not?
      @asset_item.update(user_id: nil) ? (render :json => {:message => "asset item deallocated successfully"}) : (render json: @asset_item.errors.full_messages)
    else
      render :json => {:message => "the asset is not allocated to any user"}
    end
  end

  def list_of_allocated_assets
    render json: Asset.all_asset_items_with_allocated_user
  end

  def list_of_free_assets
    render json: Asset.free_assets
  end

  private

  def asset_item_params
    params.require(:asset_item_data).permit(:asset_id, {asset_item_values_attributes: [:id ,:asset_field_id, :value]})
  end

  def filer_fields_and_values
    params[:asset_item_data][:asset_item_values_attributes] = params[:asset_item_data][:asset_item_values_attributes].uniq {|asset_field| asset_field[:asset_field_id]}
  end

  def show_asset_item_fields_and_values
    AssetField.joins(:asset_item_values).where("asset_item_values.asset_item_id = ?",@asset_item.id).select("asset_item_values.id, asset_fields.id as asset_field_id, asset_fields.field, asset_item_values.value")    
  end

  def check_asset_is_allocated_or_not?
    @asset_item.user_id.present?
  end

  def check_user_must_present
    render :json => {:message => "user must be present"} unless params[:user_id].present?
  end

end