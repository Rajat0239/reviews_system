class AddAnd < ActiveRecord::Migration[6.0]
  def change
    create_table :review_dates do |t|
      t.string  :quarter, unique: true
      t.date    :start_date
      t.date    :deadline_date
      t.timestamps
    end
  end
end
