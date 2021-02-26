class Review < ApplicationRecord
  include QuarterRelated

  # validate :can_give_review, :on => [:create]
  validate :in_a_valid_date, :on => [:create, :update]
  validates :answer, :quarter, :user_current_role, presence: true
  validates :user_id, uniqueness: { scope: [:question_for_user_id, :quarter]}

  scope :find_reporting_user_id, -> (id) {find(id).user.reporting_user_id}
  scope :current_user_current_quarter_reviews, ->(quarter) {select(:id, :ratings, :feedback, :question_for_user_id).where(quarter: quarter)} 

  belongs_to :user
  has_many :question_for_users
  has_many :feedback_by_reporting_users


  private  

    def can_give_review
      self.quarter = QuarterRelated.current_quarter
      self.user_current_role = User.find(self.user_id).current_role
    end

    def in_a_valid_date
      if QuarterRelated.is_quarter_present
        @review_date = ReviewDate.find_date(QuarterRelated.current_quarter)
        self.errors.add(:base, "review date is expired or not available") unless (@review_date.start_date ..  @review_date.deadline_date).cover?(Time.now.to_date)
      else
        self.errors.add(:base, "review date is expired or not available")
      end
    end

end
