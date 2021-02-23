class ChnageReviewTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :reviews
    create_table "reviews" do |t|
      t.belongs_to :user
      t.belongs_to :question_for_user class_name: 'question_for_user', foreign_key: 'question_id'
      t.text :answer
      t.string :quarter
      t.string :user_current_role
      t.timestamps
    end
  end
end
