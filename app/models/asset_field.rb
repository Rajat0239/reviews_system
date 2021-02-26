class AssetField < ApplicationRecord

  validates :field , presence: true, allow_blank: false
  validates_uniqueness_of :asset_id, :scope => [:field]

  belongs_to :asset
  has_many :asset_item_values, dependent: :destroy

end