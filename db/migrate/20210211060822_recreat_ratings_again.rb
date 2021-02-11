class RecreatRatingsAgain < ActiveRecord::Migration[6.0]
  def change
    drop_table :ratings
    create_table :ratings do |t|
      t.belongs_to :user
      t.string :quarter
      t.integer :ratings_by_user
      t.references :reporting_user, foreign_key: {to_table: :users}
      t.integer :ratings_by_reporting_user, :default => 1
      t.timestamps
    end
  end
end
