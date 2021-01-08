class Review < ApplicationRecord
  validates :ratings, presence: true, numericality: :only_integer, :inclusion => 1..5
  validates :feedback, presence: true
  validates :quarter, presence: true
  validates :user_current_role, presence: true
  belongs_to :user
  scope :find_reporting_user_id, -> (id) {find(id).user.reporting_user_id}
  scope :current_quarter_reviews, ->(quarter) {select(:id, :ratings, :feedback).where("status = ? AND quarter = ? ", false, quarter)}
  scope :user_current_quarter_reviews, ->(quarter) {select(:id, :ratings, :feedback)}
end
