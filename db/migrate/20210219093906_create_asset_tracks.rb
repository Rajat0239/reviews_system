class CreateAssetTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_tracks do |t|
      t.belongs_to :user
      t.belongs_to :asset_item
      t.timestamps
    end
  end
end
