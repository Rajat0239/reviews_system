class CreateAssetItemValues < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_item_values do |t|
      t.belongs_to :asset_item
      t.belongs_to :asset_field
      t.string :value
      t.timestamps
    end
  end
end
