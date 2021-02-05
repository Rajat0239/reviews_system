class DropTableReviewFeedbacks < ActiveRecord::Migration[6.0]
  def change
    drop_table :review_feedbacks
  end
end
