class AssetRequest < ApplicationRecord
  belongs_to :user
  belongs_to :asset, optional: true
  belongs_to :asset_item, optional: true

  validates :request_type, :inclusion => { :in => %w[allocation deallocation] }
  validates :status, :inclusion => { :in => %w[pending approved rejected] }
  validates_presence_of :asset, if: Proc.new { |a| a.asset_id.present? }
  validates_presence_of :asset_item, if: Proc.new { |a| a.asset_item_id.present? }
  validate :validate_asset_and_request_type, :on => [:create]

  def validate_asset_and_request_type
    errors.add(:base, 'request type must be allocataion') unless request_type == 'allocation' if asset
    errors.add(:base, 'request type must be deallocataion') unless request_type == 'deallocation' if asset_item
    errors.add(:base, 'request for asset must be present') unless asset_id || asset_item_id
  end
end
