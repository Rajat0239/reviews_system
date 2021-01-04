class CreateTableReviewAgain < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer    :ratings
      t.text       :feedback
      t.belongs_to :user
      t.references :reporting_user, foreign_key: {to_table: :users}
      t.references :user_role, foreign_key: {to_table: :roles}
      t.references :reporting_user_role, foreign_key: {to_table: :roles}
      t.boolean    :status, default: false
      t.string     :quarter
      t.timestamps
    end
  end
end
