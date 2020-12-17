class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :roles
  validates :f_name, presence: true,
  validates :l_name, presence: true
  validates :dob, presence: true
  validates :doj, presence: true
end
