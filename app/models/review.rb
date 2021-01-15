class Review < ApplicationRecord
  include QuarterRelated

  validate :can_give_review, :on => [:create]
  validate :in_a_valid_date, :on => [:create, :update]
  validates :ratings, :feedback, :quarter, :user_current_role, presence: true
  validates :ratings, numericality: :only_integer, :inclusion => 1..5

  scope :find_reporting_user_id, -> (id) {find(id).user.reporting_user_id}
  scope :current_quarter_reviews, ->(quarter) {select(:id, :ratings, :feedback).where("status = ? AND quarter = ? ", false, quarter)}
  scope :user_current_quarter_reviews, ->(quarter) {select(:id, :ratings, :feedback)}


  belongs_to :user

  private 

    def can_give_review
      self.quarter = QuarterRelated.current_quarter
      self.user_current_role = User.find(self.user_id).current_role
      self.errors.add(:base, "you already submitted the review for this quarter go to update") if User.find(self.user_id).reviews.exists?(quarter: QuarterRelated.current_quarter)
    end

    def in_a_valid_date
      if QuarterRelated.is_quarter_present
        @review_date = ReviewDate.find_date(QuarterRelated.current_quarter)
        self.errors.add(:base, "review date is expired or not available") unless ( @review_date.start_date ..  @review_date.deadline_date).cover?(Time.now.to_date)
      else
        self.errors.add(:base, "review date is expired or not available")
      end
    end

end
