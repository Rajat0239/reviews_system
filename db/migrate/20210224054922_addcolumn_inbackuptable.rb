class AddcolumnInbackuptable < ActiveRecord::Migration[6.0]
  def change
    add_column :question_backups, :question_for_user_id, :integer
  end
end
