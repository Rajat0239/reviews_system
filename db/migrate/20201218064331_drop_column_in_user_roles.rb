class DropColumnInUserRoles < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_roles, :name
  end
end
