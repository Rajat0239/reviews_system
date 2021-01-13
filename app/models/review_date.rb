class ReviewDate < ApplicationRecord
  after_create :send_an_email_to_users

  validate :validate_start_date, :on => :create
  validate :validate_deadline_date, :on => :update
  validates :start_date, :deadline_date, :quarter, presence: true
  validates_uniqueness_of :quarter

  scope :find_date, -> (current_quarter) {find_by(quarter: current_quarter)}
  scope :date_for_quarter, -> (current_quarter) {find_by(quarter: current_quarter)}

  private
    def validate_start_date
      self.errors.add(:base, "date is invalid") if !(self.start_date >= Date.today)
    end

    def validate_deadline_date
      byebug
      self.errors.add(:base, "date is invalid") if !(self.deadline_date >= self.start_date)
    end

    def send_an_email_to_users
      UserMailer.review_date_email(self).deliver_now
    end
end
