class AddforginkeyForFeedabacktable < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :reviews, :reporting_uesr_feedbacks, column: :user_id
  end
end
