class UserRole < ApplicationRecord
  validates :name, presence: true
  belongs_to :user
  belongs_to :role
end
