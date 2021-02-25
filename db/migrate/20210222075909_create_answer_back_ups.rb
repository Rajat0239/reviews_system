class CreateAnswerBackUps < ActiveRecord::Migration[6.0]
  def change
    create_table :answer_back_ups do |t|
      t.belongs_to :question_back_up
      t.string :answer
      t.string :review
      t.string :feedback
      t.string :quarter
      t.string :f_name
      t.string :l_name
      t.string :email
      t.string :dob
      t.string :doj
      t.timestamps
    end
 
    create_table :question_back_ups do |t|
      t.integer :question_id
      t.string :question
      t.string :question_type
      t.string :option 
      t.timestamps
    end
  end
end
