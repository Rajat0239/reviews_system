class Role < ApplicationRecord

  validates :name, presence: true

  scope :find_role, ->(id) {find(id).name}
  
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :questions_for_user

end
