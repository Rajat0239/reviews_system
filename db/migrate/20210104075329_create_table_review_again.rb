class CreateTableReviewAgain < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :user
      t.integer    :ratings
      t.text       :feedback
      t.string     :quarter
      t.boolean    :status, default: false      
      t.string     :user_current_role
      t.timestamps
    end
  end
end
