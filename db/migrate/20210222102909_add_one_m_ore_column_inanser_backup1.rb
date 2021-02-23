class AddOneMOreColumnInanserBackup1 < ActiveRecord::Migration[6.0]
  def change
    add_column :answer_back_ups, :reporting_user_id, :integer
    remove_column :answer_back_ups, :review
  end
end