class RecreateAssetRequest < ActiveRecord::Migration[6.0]
  def change
    drop_table :asset_requests
    create_table :asset_requests do |t|
      t.belongs_to :user
      t.belongs_to :asset
      t.belongs_to :asset_item
      t.text :comment_by_user
      t.text :comment_by_admin
      t.string :request_type
      t.string :status, default: 'pending'
      t.timestamps
    end
  end
end
