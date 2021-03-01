class Question < ApplicationRecord
  
  before_destroy :question_backup, prepend: true
  
  @@question_valid_status = true
  
  validate :check_reviewdate, :on => [:update]
  validate :check_valid_question_id, :set_options_nill_if_q_type_is_feedback, :on => [:create]
  validates :question, presence: true
  validates :question, uniqueness: { scope: [:question], message: " This Question has already created !" }
  validates :options, presence: true, if: :if_options_are?
  
  belongs_to :question_type
  has_many :question_backups
  has_many :question_for_users
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
      question = QuestionForUser.find_by(question_id:self.id)
      if question.present?
        if (Time.now.to_date).before?(@review_date.start_date) != true
          self.errors.add(:message, "Sorry, You Are Not Allowed to Access This Action")
          throw(:abort)
        end 
      else
        return   
      end
    else
      return self.errors.add(:message, "Sorry, You Are Not Allowed to Access This Action")
    end 
  end

  def question_backup
    @question = self.question_backups.new(questions:self.question,options:self.options,question_type_id:self.question_type_id)
    if @question.save
      return
    else
      self.errors.add(:message, "(#{@question.errors.full_messages})")
      throw(:abort)
    end 
  end  
end