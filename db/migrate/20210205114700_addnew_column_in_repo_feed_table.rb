class AddnewColumnInRepoFeedTable < ActiveRecord::Migration[6.0]
  def change
    add_column :feedback_by_reporting_users, :status, :boolean
  end
end
