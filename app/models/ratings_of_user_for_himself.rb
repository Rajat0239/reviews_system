class RatingsOfUserForHimself < ApplicationRecord

  validates_inclusion_of :ratings, :in => 1..5
  validates :quarter, presence: true

  belongs_to :user

end
