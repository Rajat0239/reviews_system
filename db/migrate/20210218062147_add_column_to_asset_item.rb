class AddColumnToAssetItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :asset_items, :user
  end
end
