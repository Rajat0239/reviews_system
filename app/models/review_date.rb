class ReviewDate < ApplicationRecord
  validates :start_date, presence: true
  validates :deadline_date, presence: true
  validates :quarter, presence: true
  validates_uniqueness_of :quarter
  scope :find_date, -> (current_quarter) {find_by(quarter: current_quarter)}
end
