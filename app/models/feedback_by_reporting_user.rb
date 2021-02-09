class FeedbackByReportingUser < ApplicationRecord

  validates :feedback, :quarter, presence: true
  validates :feedback_by_reporting_users, uniqueness: { scope: [:feedback_for_user_id, :quarter], message: 'You have already given feedback for this User!'}
  belongs_to :user
  
end
