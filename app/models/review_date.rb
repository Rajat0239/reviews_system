class ReviewDate < ApplicationRecord
  after_create :send_an_email_to_users

  validate :check_before_create, :on => :create
  validate :validate_deadline_date, :on => [:create]
  validate :check_before_update, :on => [:update]
  validates :start_date, :deadline_date, :quarter, presence: true
  validates_uniqueness_of :quarter

  scope :find_date, -> (current_quarter) {find_by(quarter: current_quarter)}
  scope :date_for_quarter, -> (current_quarter) {find_by(quarter: current_quarter)}

  private
    def check_before_create
      unless is_quarter_present
        self.errors.add(:base, "start date is invalid") unless current_quarter == quarter_related_to_date(self.start_date) && (self.start_date >= Date.today)
      else
        self.errors.add(:base, "date is already generated for the quarter go to update")
      end
    end

    def validate_deadline_date
        self.errors.add(:base, "deadline date is invalid") unless current_quarter == quarter_related_to_date(self.deadline_date) && (self.deadline_date > self.start_date)
    end
    
    def check_before_update
      if is_quarter_present
        validate_deadline_date
      else
        self.errors.add(:base, "can't update the date")
      end
    end

    def current_quarter
      ((Time.now.month - 1)/3+1).to_s+" "+(Time.now.year).to_s
    end
    
    def quarter_related_to_date(date)
      ((date.to_date.month-1)/3+1).to_s+" "+ date.to_date.year.to_s
    end

    def is_quarter_present
      ReviewDate.exists?(quarter: current_quarter)
    end
        
    def send_an_email_to_users
      UserMailer.review_date_email(self).deliver_now
    end
end



