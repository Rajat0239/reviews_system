class CreateTableDates < ActiveRecord::Migration[6.0]
  def change
    create_table :review_dates do |t|
      t.belongs_to :user
      t.string  :quarter
      t.date    :review_date
      t.date    :review_deadline_date
      t.timestamps
    end
  end
end
