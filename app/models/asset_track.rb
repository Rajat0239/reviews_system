class AssetTrack < ApplicationRecord
  belongs_to :asset_item
  belongs_to :user, optional: true

  scope :all_asset_track, -> { joins("INNER JOIN asset_items on asset_tracks.asset_item_id = asset_items.id INNER JOIN assets on asset_items.asset_id = assets.id INNER JOIN users on asset_tracks.user_id = users.id").select("asset_tracks.id, (assets.name || ' ' || asset_items.asset_count) as 'asset_item_name', users.f_name || ' ' || users.l_name as 'user_name', asset_tracks.created_at")}
end
