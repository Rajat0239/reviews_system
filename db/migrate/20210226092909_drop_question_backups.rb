class DropQuestionBackups < ActiveRecord::Migration[6.0]
  def change
    drop_table :question_backups
  end
end
