class CreateAssetFields < ActiveRecord::Migration[6.0]
  def change
    create_table :asset_fields do |t|
      t.belongs_to :asset
      t.string :field
      t.timestamps
    end
  end
end
