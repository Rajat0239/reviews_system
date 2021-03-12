class QuestionForUser < ApplicationRecord

  before_destroy :check_date, prepend: true

  validate :check_date, :on => [:update]
  validates :question_id, uniqueness: { scope: [:question_id, :quarter, :role_id], message: 'You have already add this question for this role in prasent quarter!'}
  # validates :status, presence: true
  
  belongs_to :role
  belongs_to :question
  has_many :reviews

  def check_date
    if QuarterRelated.is_quarter_present 
      @review_date = ReviewDate.find_date(QuarterRelated.current_quarter)
      if (Time.now.to_date).before?(@review_date.start_date) == true
       return
      else
        self.errors.add(:message, "Sorry, You Are Not Allowed to Access This Action") 
        throw(:abort)
      end  
    else
      return self.errors.add(:message, "Sorry, You Are Not Allowed to Access This Action")
    end
  end

end

