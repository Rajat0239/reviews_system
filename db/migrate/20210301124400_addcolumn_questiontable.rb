class AddcolumnQuestiontable < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :status , :Boolean
  end
end
