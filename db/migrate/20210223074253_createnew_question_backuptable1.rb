class CreatenewQuestionBackuptable1 < ActiveRecord::Migration[6.0]
  drop_table :question_backups
  create_table "question_backups" do |t|
    t.belongs_to :ques
    t.string :question
    t.string :option
    t.timestamps
  end
end
