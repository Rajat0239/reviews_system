class Review < ApplicationRecord
  validates :ratings, presence: true, numericality: :only_integer, :inclusion => 1..5
  validates :feedback, presence: true
  validates :reporting_user_id, presence: true
  validates :quarter, presence: true
  validates :user_current_role, presence: true
  validates :reporting_user_current_role, presence: true
  belongs_to :user
end
