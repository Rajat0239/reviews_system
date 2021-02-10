class CreateNewQuestionTable < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.text :question
      t.belongs_to :role
      t.belongs_to :question_type
      t.string :options
      t.timestamps
    end
  end
end
