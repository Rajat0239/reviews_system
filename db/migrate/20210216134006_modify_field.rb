class ModifyField < ActiveRecord::Migration[6.0]
  def change
    rename_column :asset_items, :asset_count, :integer
  end
end
