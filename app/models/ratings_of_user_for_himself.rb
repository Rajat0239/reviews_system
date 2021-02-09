class RatingsOfUserForHimself < ApplicationRecord

  validates_inclusion_of :ratings, :in => 1..5
  validates :quarter, presence: true
  validates_uniqueness_of :user, :scope => [:user_id, :quarter]

  belongs_to :user

end
