class AssetTrack < ApplicationRecord
  belongs_to :asset_item
  belongs_to :user, optional: true

  validates_presence_of :assigned_on
end
