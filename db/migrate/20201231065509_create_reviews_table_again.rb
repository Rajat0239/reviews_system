class CreateReviewsTableAgain < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :user
      t.integer    :ratings
      t.text       :feedback
      t.references :reporting_user, foreign_key: {to_table: :users}
      t.boolean    :status, default: false
      t.timestamps
    end
  end
end
