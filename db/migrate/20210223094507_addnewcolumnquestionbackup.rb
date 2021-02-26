class Addnewcolumnquestionbackup < ActiveRecord::Migration[6.0]
  def change
    add_column :question_backups, :question_type_id, :integer
  end
end
