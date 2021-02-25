class AddStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :active_status, :boolean, default: true
  end
end
