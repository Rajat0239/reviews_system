class RenameColumnInassetItem < ActiveRecord::Migration[6.0]
  def change
    rename_column :asset_items, :integer, :asset_count
  end
end
