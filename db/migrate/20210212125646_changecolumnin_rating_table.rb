class ChangecolumninRatingTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :ratings, :ratings_by_user
    add_column :ratings, :ratings_by_user, :integer, :default => 0
  end
end
