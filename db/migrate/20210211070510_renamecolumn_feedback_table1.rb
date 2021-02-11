class RenamecolumnFeedbackTable1 < ActiveRecord::Migration[6.0]
  def change
    rename_column :feedback_by_reporting_users, :reporting_user_id, :user_id
  end
end
