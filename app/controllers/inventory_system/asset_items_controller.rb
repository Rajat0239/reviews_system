class InventorySystem::AssetItemsController < ApplicationController

  before_action :filer_fields_and_values, :check_all_fields_must_present, only: [:create]
  before_action :check_user_must_present, only: [:allocation_of_assets]

  def index
    render json: Asset.all_asset_items
  end

  def show
    @asset_item
  end

  def create
    @asset_item = @asset.asset_items.new(asset_item_params)
    @asset_item.save ? success_response("asset item added succussfully") : faliure_response(@asset_item.errors.full_messages)
  end

  def update
    @asset_item.update(asset_item_params) ? success_response("asset item updated succussfully") : faliure_response(@asset_item.errors.full_messages)
  end

  def destroy
    @asset_item.destroy ? success_response("asset item deleted succussfully") : faliure_response(@asset_item.errors.full_messages)
  end

  def allocation_of_assets
    byebug
    unless check_asset_is_allocated_or_not?
      @asset_item.update(user_id: params[:user_id]) ? success_response("asset item allocated successfully") : faliure_response(@asset_item.errors.full_messages)
    else
      render :json => {:message => "the asset is already allocated to the user"}
    end
  end

  def deallocation_of_assets
    if check_asset_is_allocated_or_not?
      @asset_item.update(user_id: nil) ? success_response("asset item deallocated successfully") : faliure_response(@asset_item.errors.full_messages)
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

  def asset_item_history
    @asset_item
  end

  def all_asset_items_history
    @asset_items = AssetItem.all
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

  def check_all_fields_must_present
    @asset = Asset.find(params[:asset_item_data][:asset_id])
    faliure_response("all fields must be present") unless params[:asset_item_data][:asset_item_values_attributes].count == @asset.asset_fields.count
  end
end
