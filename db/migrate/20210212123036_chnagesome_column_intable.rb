class ChnagesomeColumnIntable < ActiveRecord::Migration[6.0]
  def change
    remove_column :feedback_by_reporting_users, :status
    drop_table :ratings
      create_table :ratings do |t|
        t.belongs_to :user
        t.belongs_to :reporting_user
        t.string :quarter
        t.string :ratings_by_user
        t.integer :ratings_by_reporting_user, :default => 0
        t.integer :rating_by_admin, :default => 0
        t.text :feedback_by_admin
        t.string :status
        t.timestamps
      end
  end
end
