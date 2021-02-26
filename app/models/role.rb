class Role < ApplicationRecord

  validates :name, presence: true

  scope :find_role, ->(id) {find(id).name}
  
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :question_for_users
  has_many :questions, through: :question_for_users

end
