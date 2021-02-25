class Question < ApplicationRecord

  @@question_valid_status = true
  
  validate :check_reviewdate, :on => [:update]
  validate :check_valid_question_id, :set_options_nill_if_q_type_is_feedback, :on => [:create]
  validates :question, presence: true
  validates :question, uniqueness: { scope: [:question], message: 'has already created !' }
  validates :options, presence: true, if: :if_options_are?
  before_destroy :question_backup, prepend: true
  
  belongs_to :question_type
  has_many :question_for_users, :dependent => :delete_all
  has_many :roles, through: :question_for_users

  def set_options_nill_if_q_type_is_feedback
    self.options = nil if (self.question_type.q_type == "text" || self.question_type.q_type == "true-false") if @@question_valid_status == true
  end

  def if_options_are?
    (self.question_type.q_type == "choose-the-correct" || self.question_type.q_type == "checkbox") if @@question_valid_status == true
  end

  def check_valid_question_id
    unless self.question_type
      @@question_valid_status = false
    end
  end

  def check_reviewdate
    if QuarterRelated.is_quarter_present 
      @review_date = ReviewDate.find_date(QuarterRelated.current_quarter)
      if (Time.now.to_date).before?(@review_date.start_date) != true
        self.errors.add(:message, "Sorry, You Are Not Allowed to Access This Action")
        throw(:abort)
      end  
    else
      return self.errors.add(:message, "Sorry, You Are Not Allowed to Access This Action")
    end 
  end

  def question_backup
    @question = Question.find(self.id)
    @question = QuestionBackUp.new(question_id: @question.id, question: @question.question, question_type: @question.question_type_id, option: @question.options)
    if @question.save
      question_forusers = QuestionForUser.where(question_id:self.id).select("id")
      if !question_forusers.empty? 
        question_forusers.map do |data|
          review_ids = Review.where(question_for_user_id:data.id).select("id")
          if !review_ids.empty?
            review_ids.map do |review|
              review_data = Review.find(review.id) if review.id.present?
              feedback_data = FeedbackByReportingUser.find_by(review_id:review_data.id) if review_data.id.present?
              user_details = User.find(review_data.user_id) if review_data.user_id.present?
              answer = AnswerBackUp.new(question_back_up_id: @question.id, answer: review_data.answer, feedback: feedback_data.feedback, quarter: review_data.quarter, f_name:user_details.f_name, l_name:user_details.l_name, email:user_details.email, dob:user_details.dob, doj:user_details.doj, reporting_user_id:user_details.reporting_user_id)
              answer.save
            end 
          end  
        end
      end
    else 
      self.errors.add(:message, "#{@question.save.errors}")
      throw(:abort)
    end  
  end  
end