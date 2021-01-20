class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.text :question
      t.belongs_to :role
      t.timestamps
    end
  end
end
