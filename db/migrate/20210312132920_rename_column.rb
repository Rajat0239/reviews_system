class RenameColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :asset_items, :integer, :integer 
  end
end
