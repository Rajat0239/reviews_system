class CreateNewFeedBackTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :feedback_by_reporting_users
      create_table :feedback_by_reporting_users do |t|
        t.belongs_to :review
        t.integer :reporting_user_id
        t.text :feedback
        t.string :quarter
        t.string :status
        t.timestamps
      end
  end
end
