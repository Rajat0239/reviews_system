class Review < ApplicationRecord
  validates :ratings, presence: true, numericality: :only_integer
  validates :feedback, presence: true
  belongs_to :user
end
