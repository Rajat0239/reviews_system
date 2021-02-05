class CreateReportingUesrFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :reporting_uesr_feedbacks do |t|
      t.integer :user_id
      t.string :quarter
      t.string :review_feedback
      t.timestamps
    end
  end
end
