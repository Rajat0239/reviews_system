class Role < ApplicationRecord
  belongs_to :user
  has_many :user_roles
end
