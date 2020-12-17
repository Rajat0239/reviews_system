class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.belongs_to :user
      t.string :name
    end
  end
end
