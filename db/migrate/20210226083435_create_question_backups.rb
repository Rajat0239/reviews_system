class CreateQuestionBackups < ActiveRecord::Migration[6.0]
  def change
    drop_table :question_backups
    create_table :question_backups do |t|
      t.integer :question_id
      t.integer :question_type_id
      t.string :question
      t.string :options
    end
  end
end
