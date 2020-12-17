class Role < ApplicationRecord
  belongs_to :user
  has_many :user_roles
  validates :name, presence: true
end
