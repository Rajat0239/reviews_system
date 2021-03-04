class ModifyStatusToQuestion < ActiveRecord::Migration[6.0]
  def change
    change_column :questions, :status, :boolean, default: :true
  end
end
