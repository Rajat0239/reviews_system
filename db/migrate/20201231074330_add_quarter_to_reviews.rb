class AddQuarterToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :quarter, :string
  end
end
