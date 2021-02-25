class AddnewcolumnInQuestionForuser < ActiveRecord::Migration[6.0]
  def change
    add_column :question_for_users, :status, :string
  end
end
