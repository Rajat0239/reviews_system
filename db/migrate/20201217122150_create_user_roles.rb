class CreateUserRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_roles do |t|
      t.belongs_to :role
      t.belongs_to :user
      t.string :name
    end
  end
end
