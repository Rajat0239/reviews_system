class AddColumnToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :user_current_role, :string
    add_column :reviews, :reporting_user_current_role, :string
  end
end
