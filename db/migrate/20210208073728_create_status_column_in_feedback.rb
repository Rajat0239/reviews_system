class CreateStatusColumnInFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :feedback_by_reporting_users, :status, :string
  end
end
