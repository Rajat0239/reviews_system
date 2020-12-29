class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :user
      t.integer    :ratings
      t.text       :feedback
      t.boolean    :status, default: false
      t.timestamps
    end
  end
end
