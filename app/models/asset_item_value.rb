class AssetItemValue < ApplicationRecord

  validate :check_valid_field, :on => [:create, :update]
  validates :value, presence: true, allow_blank: false
  validates_uniqueness_of :asset_item_id, :scope => [:asset_field_id]

  belongs_to :asset_field
  belongs_to :asset_item  

  private

  def check_valid_field
    self.errors.add(:base, "field is not of asset") unless AssetField.find_by(asset_id: self.asset_item.asset_id, id: self.asset_field_id).present?
  end

end