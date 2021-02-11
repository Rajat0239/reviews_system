class CreateNewFeedbackTable1 < ActiveRecord::Migration[6.0]
  def change
    drop_table :feedback_by_reporting_users
      create_table :feedback_by_reporting_users do |t|
        t.belongs_to :review
        t.references :reporting_user, foreign_key: {to_table: :users}
        t.references :feedback_for_user , foreign_key: {to_table: :users}
        t.text :feedback
        t.string :quarter
        t.string :status
        t.timestamps
      end
  end
end
