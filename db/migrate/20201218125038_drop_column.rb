class DropColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :authentication_token
  end
end
