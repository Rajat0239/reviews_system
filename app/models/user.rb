class User < ApplicationRecord
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, presence: true
  validates :f_name,          presence: true
  validates :l_name,          presence: true
  validates :dob,             presence: true
  validates :doj,             presence: true
  validates :current_role,    presence: true
  validates :reporting_user_id, presence: true
  has_many :reviews, dependent: :destroy
  has_many :user_roles, dependent: :destroy 
  has_many :roles, through: :user_roles
  accepts_nested_attributes_for :user_roles, allow_destroy: true
end
