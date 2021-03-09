class RemoveColumnInQuestionBackup < ActiveRecord::Migration[6.0]
  def change
    remove_column :question_backups, :question_for_user_id
    rename_column :question_backups, :ques, :questions
    rename_column :question_backups, :option, :options
  end
end
