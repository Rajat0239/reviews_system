class AddStatusToQuestion < ActiveRecord::Migration[6.0]
  def change
    modify_column :questions, :status, :boolean, default: :true
  end
end
