class RecreateAssetTracks < ActiveRecord::Migration[6.0]
  def change
    drop_table :asset_tracks
    create_table :asset_tracks do |t|
      t.belongs_to :user
      t.belongs_to :asset_item
      t.datetime :assigned_on
      t.datetime :submitted_on, default: nil
    end
  end
end
