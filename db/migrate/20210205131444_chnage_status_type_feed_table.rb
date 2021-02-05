class ChnageStatusTypeFeedTable < ActiveRecord::Migration[6.0]
  def change
    change_column :feedback_by_reporting_users, :status, :string
  end
end
