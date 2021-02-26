class InventorySystem::AssetsController < ApplicationController

  respond_to :html

  before_action :filer_fields, only: [:create, :update]

  def index
    render json: Asset.all.select(:id , :name) 
  end

  def show
    render json: show_asset_with_fields
  end

  def create
    @asset = Asset.new(asset_params)
    @asset.save ? (render :json => {:message => "asset created succussfully"}) : (render json: @asset.errors.full_messages)
  end

  def update
    @asset.update(asset_params) ? (render :json => {:message => "asset updated succussfully"}) : (render json: @asset.errors.full_messages)
  end

  def destroy
    @asset.destroy ? (render :json => {:message => "asset deleted succussfully"}) : (render json: @asset.errors.full_messages)
  end

  def show_asset_items
  end

  def show_allocated_assets
    render json: @asset.asset_items.where("asset_items.user_id IS NOT NULL").joins(:asset).joins(:user).select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as asset_name, (users.f_name || ' ' || users.l_name) as user_name")
  end

  def show_free_assets
    render json: @asset.asset_items.where("asset_items.user_id IS NULL").joins(:asset).select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as asset_name") 
  end

  private

  def asset_params
    params.require(:asset_data).permit(:name, {asset_fields_attributes: [:id, :field]})
  end

  def filer_fields
    params[:asset_data][:asset_fields_attributes] = params[:asset_data][:asset_fields_attributes].uniq {|field| field[:field]}
  end

  def show_asset_with_fields
    {asset_data: {id: @asset.id, name: @asset.name}, asset_fields_attributes: @asset.asset_fields.select(:id, :field)}    
  end

end