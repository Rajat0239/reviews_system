class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :f_name, presence: true
  validates :l_name, presence: true
  validates :dob, presence: true
  validates :doj, presence: true
  has_many :user_roles
  has_many :roles, through: :user_roles
end
