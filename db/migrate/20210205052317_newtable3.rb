class Newtable3 < ActiveRecord::Migration[6.0]
  def change
    drop_table :reporting_uesr_feedbacks
    create_table :reporting_uesr_feedbacks do |t|
      t.integer :review_user_id
      t.string :quarter
      t.text :review_feedback
      t.integer :user_id
      t.timestamps
    end 
  end
end
