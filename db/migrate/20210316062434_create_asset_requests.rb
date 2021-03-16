class CreateAssetRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_requests do |t|
      t.belongs_to :user
      t.belongs_to :asset
      t.text :reason
      t.boolean :status, default: false
      t.timestamps
    end
  end
end
