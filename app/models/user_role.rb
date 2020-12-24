class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
  validates_uniqueness_of :user, :scope => [:role_id, :user_id]
end
