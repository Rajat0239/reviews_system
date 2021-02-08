class CreateRatingsOfUserForHimselves < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings_of_user_for_himselves do |t|
      t.belongs_to :user
      t.string :quarter
      t.integer :ratings
      t.timestamps
    end
  end
end
