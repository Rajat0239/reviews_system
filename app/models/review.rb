class Review < ApplicationRecord
  include QuarterRelated

  validate :can_give_review, :on => [:create]
  validate :in_a_valid_date, :on => [:create, :update]
  validates :ratings, :feedback, :quarter, :user_current_role, presence: true
  validates :ratings, numericality: :only_integer, :inclusion => 1..5
  validates :user_id, uniqueness: { scope: [:question_id, :quarter] }

  scope :find_reporting_user_id, -> (id) {find(id).user.reporting_user_id}
  scope :current_quarter_reviews, ->(quarter) {select(:id, :ratings, :feedback, :status).where("status = ? AND quarter = ? ", true, quarter)}
  scope :user_current_quarter_reviews, ->(quarter) {select(:id, :ratings, :feedback)}
  scope :present_quater_reviews, ->(quarter) {where(quarter: quarter)}
  scope :over_all_ratings_of_user, ->(user_id) {where("quarter like ? AND user_id = ? AND status = ?","%#{Date.today.year}",user_id,true).pluck(:ratings).sum}
 

  belongs_to :user
  belongs_to :question

  private 

    def can_give_review
      self.errors.add(:base, "you already submitted the review for this quarter go to update") if (User.find(self.user_id).reviews.exists?(quarter: self.quarter)) && (Review.find_by(question_id: self.question_id))
      self.errors.add(:base, "you can't review this") unless Role.find_by(name: User.find(self.user_id).current_role).id == Question.find(self.question_id).role_id
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
