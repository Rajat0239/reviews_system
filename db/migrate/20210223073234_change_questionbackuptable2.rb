class ChangeQuestionbackuptable2 < ActiveRecord::Migration[6.0]
  def change
    drop_table :answer_back_ups
    drop_table :question_back_ups
    drop_table :question_backups
  end
end
