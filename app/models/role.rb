class Role < ApplicationRecord
  validates :name, presence: true
  scope :find_role, ->(id) {find(id)}
  has_many :user_roles
  has_many :users, through: :user_roles
end
