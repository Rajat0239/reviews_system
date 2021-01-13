class User < ApplicationRecord
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_save :send_welcome_mail

  validates :f_name, :l_name, :dob, :doj, :current_role, :reporting_user_id,  presence: true

  scope :find_user, ->(id) {find(id)}
  scope :is_present, ->(id) {find_by(id)}

  has_many :reviews, dependent: :destroy
  has_many :user_roles, dependent: :destroy 
  has_many :roles, through: :user_roles
  accepts_nested_attributes_for :user_roles, allow_destroy: true

  private
    def send_welcome_mail
      UserMailer.send_welcome_mail(self.email).deliver_now
    end
end
