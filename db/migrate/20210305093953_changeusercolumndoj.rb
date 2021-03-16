class Changeusercolumndoj < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :doj
    add_column :users, :doj, :date
  end
end
