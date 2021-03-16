class CreateFeedbackByReportingUser < ActiveRecord::Migration[6.0]
  def change
    drop_table :feedback_by_reporting_users
    create_table :feedback_by_reporting_users do |t|
      t.belongs_to :user
      t.text :feedback
      t.string :quarter
      t.references :feedback_for_user, foreign_key: {to_table: :user}
      t.timestamps
    end
  end
end
