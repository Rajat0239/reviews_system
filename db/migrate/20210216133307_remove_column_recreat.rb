class RemoveColumnRecreat < ActiveRecord::Migration[6.0]
  def change
    rename_column :asset_items, :name, :asset_count
  end
end
