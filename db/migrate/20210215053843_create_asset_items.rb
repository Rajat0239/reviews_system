class CreateAssetItems < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_items do |t|
      t.belongs_to :asset
      t.string :name
      t.timestamps
    end
  end
end
