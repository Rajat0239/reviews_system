class Question < ApplicationRecord

  @@question_valid_status = true
  
  validate :do_not_update_if_in_review_date_range, :on => [:update]
  validate :check_valid_question_id, :set_options_nill_if_q_type_is_feedback, :on => [:create]
  validates :question, presence: true
  validates :question, uniqueness: { scope: [:question], message: " This Question has already created !" }
  validates :options, presence: true, if: :if_options_are?
  
  belongs_to :question_type
  has_many :question_for_users
  has_many :roles, through: :question_for_users

  def set_options_nill_if_q_type_is_feedback
    self.options = nil if (self.question_type.q_type == "text" || self.question_type.q_type == "true-false") if @@question_valid_status == true
  end

  def if_options_are?
    (self.question_type.q_type == "choose-the-correct" || self.question_type.q_type == "checkbox") if @@question_valid_status == true
  end

  def check_valid_question_id
    @@question_valid_status = false unless self.question_type
  end

  def do_not_update_if_in_review_date_range
    @review_date = ReviewDate.find_date(QuarterRelated.current_quarter)
    allotted_ids = QuestionForUser.where(question_id:self.id).select("id")
    self.errors.add(:message, "you can't delete this question. when in review date range") if (@review_date.start_date ..  @review_date.deadline_date).cover?(Time.now.to_date) && !allotted_ids.empty?
  end

end