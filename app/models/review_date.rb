class ReviewDate < ApplicationRecord
  include QuarterRelated
  
  after_create :send_an_email_to_users

  validate :check_before_create, :on => [:create]
  validate :check_before_update, :on => [:update]
  validates :start_date, :deadline_date, :quarter, presence: true
  validates_uniqueness_of :quarter

  scope :find_date, -> (current_quarter) {find_by(quarter: current_quarter)}
  scope :date_for_quarter, -> (current_quarter) {find_by(quarter: current_quarter)}

  private
    def check_before_create
      unless QuarterRelated.is_quarter_present
        self.quarter = QuarterRelated.current_quarter
        validate_both_date
      else
        self.errors.add(:base, "date is already generated for the quarter go to update")
      end
    end
    
    def check_before_update
      if QuarterRelated.is_quarter_present
        validate_both_date
      else
        self.errors.add(:base, "can't update the date")
      end
    end
    
    def validate_both_date
      self.errors.add(:base, "deadline date is invalid") unless QuarterRelated.current_quarter == QuarterRelated.quarter_related_to_date(self.deadline_date) && (self.deadline_date > self.start_date)
      self.errors.add(:base, "start date is invalid") unless QuarterRelated.current_quarter == QuarterRelated.quarter_related_to_date(self.start_date) && (self.start_date >= Date.today)
    end
    
    def send_an_email_to_users
      UserMailer.review_date_email(self).deliver_now
    end
    
end



