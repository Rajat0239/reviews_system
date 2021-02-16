class CreateNewTableforuserQues < ActiveRecord::Migration[6.0]
  def change
    remove_column :questions, :role_id
    create_table :question_for_users do |t|
      t.belongs_to :role
      t.belongs_to :question
      t.string :quarter
      t.timestamps
    end
  end
end
