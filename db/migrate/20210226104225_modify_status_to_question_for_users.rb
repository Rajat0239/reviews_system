class ModifyStatusToQuestionForUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :question_for_users, :status, :boolean, default: :true
  end
end
