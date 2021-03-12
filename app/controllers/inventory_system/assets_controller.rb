class InventorySystem::AssetsController < ApplicationController

  before_action :filer_fields, only: [:create, :update]

  def index
    render json: Asset.all.select(:id , :name) 
  end

  def show
    render json: show_asset_with_fields
  end

  def create
    @asset = Asset.new(asset_params)
    @asset.save ? success_response("asset created succussfully") : faliure_response(@asset.errors.full_messages)
  end

  def update
    @asset.update(asset_params) ? success_response("asset updated succussfully") : faliure_response(@asset.errors.full_messages)
  end

  def destroy
    @asset.destroy ? success_response("asset deleted succussfully") : faliure_response(@asset.errors.full_messages)
  end

  def show_asset_items
    @asset
  end

  def show_allocated_assets
    render json: @asset.asset_items.where("asset_items.user_id IS NOT NULL").joins(:asset).joins(:user).select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as asset_name, (users.f_name || ' ' || users.l_name) as user_name")
  end

  def show_free_assets
    render json: @asset.asset_items.where("asset_items.user_id IS NULL").joins(:asset).select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as asset_name") 
  end

  def show_assets_with_free_items
    @assets = Asset.all
  end

  def show_assets_with_allocated_items
    @assets = Asset.all
  end

  private

  def asset_params
    params.require(:asset_data).permit(:name, {asset_fields_attributes: [:id, :field, :_destroy] } )
  end

  def filer_fields
    params[:asset_data][:asset_fields_attributes] = params[:asset_data][:asset_fields_attributes].uniq { |field| field[:field]}
  end

  def show_asset_with_fields
    {asset_data: { id: @asset.id, name: @asset.name}, asset_fields_attributes: @asset.asset_fields.select(:id, :field)}
  end
end
