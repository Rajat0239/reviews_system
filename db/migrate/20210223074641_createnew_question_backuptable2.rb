class CreatenewQuestionBackuptable2 < ActiveRecord::Migration[6.0]
  def change
    rename_column :question_backups, :ques_id, :question_id
    rename_column :question_backups, :question, :ques
  end
end
