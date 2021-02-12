class Rating < ApplicationRecord
  validates_inclusion_of :ratings_by_user, :ratings_by_reporting_user, :in => 0..5
  validates :quarter, presence: true
  validates_uniqueness_of :user, :scope => [:user_id, :quarter, :reporting_user_id]

  belongs_to :user
end
