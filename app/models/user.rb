class User < ApplicationRecord
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
       
  after_create :send_welcome_mail
  
  validate :is_reporting_role_manager, :on => [:create, :update]
  validates :f_name, :l_name, :dob, :doj, :current_role, :reporting_user_id,  presence: true

  scope :find_user, ->(id) {find(id)}
  scope :is_email_present, ->(email) {find_by(email: email)}
  scope :excluding_admin, ->{where.not(current_role: "admin")}

  has_many :reviews, dependent: :destroy
  has_many :user_roles, dependent: :destroy 
  has_many :roles, through: :user_roles
  accepts_nested_attributes_for :user_roles, allow_destroy: true

  
  private
  
    def send_welcome_mail
      UserMailer.send_welcome_mail(self.email).deliver_now
    end

    def is_reporting_role_manager
      self.errors.add(:base, "reporting user role is not a manager") unless User.find(self.reporting_user_id).current_role == "manager"
    end
end
