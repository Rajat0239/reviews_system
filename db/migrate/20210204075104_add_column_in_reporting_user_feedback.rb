class AddColumnInReportingUserFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :reporting_uesr_feedbacks, :reporting_user_id, :integer
    rename_column :reporting_uesr_feedbacks, :review_feedback, :reporting_user_feedback
  end
end
