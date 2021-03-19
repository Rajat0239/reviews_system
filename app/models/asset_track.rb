class AssetTrack < ApplicationRecord
  belongs_to :asset_item
  belongs_to :user, optional: true
end
