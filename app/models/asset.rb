class Asset < ApplicationRecord

  validates_uniqueness_of :name
  validates :name, presence: true, allow_blank: false

  has_many :asset_fields, dependent: :destroy
  has_many :asset_items, dependent: :destroy
  has_many :asset_requests

  accepts_nested_attributes_for :asset_fields, allow_destroy: true

  scope :all_asset_items, -> {joins(:asset_items).select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as 'asset_item'")}
  scope :individual_asset_items, ->(id) {joins(:asset_items).where("asset_items.asset_id = ?",id).select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as 'asset_item'")}
  scope :all_asset_items_with_allocated_user, -> {joins("INNER JOIN asset_items on assets.id = asset_items.asset_id INNER JOIN users on users.id = asset_items.user_id").select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as 'asset_item', (users.f_name || ' ' || users.l_name) as allocated_to")}
  scope :free_assets, -> {joins(:asset_items).where("asset_items.user_id IS NULL").select("asset_items.id, (assets.name || ' ' || asset_items.asset_count) as 'asset_item'")}

end
  