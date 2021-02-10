class Question < ApplicationRecord

  @@question_valid_status = true

  validate :check_valid_question_id, :set_options_nill_if_q_type_is_feedback, :check_question_is_for_valid_user, :on => [:create]
  validates :options, presence: true, if: :if_options_are?
  validates :question, :role_id, presence: true 
  validates_uniqueness_of :question, :scope => [:question, :role_id]

  belongs_to :role
  belongs_to :question_type
  has_many :reviews

  def set_options_nill_if_q_type_is_feedback
    self.options = nil if (self.question_type.q_type == "text" || self.question_type.q_type == "true-false") if @@question_valid_status == true
  end

  def if_options_are?
    (self.question_type.q_type == "choose-the-correct" || self.question_type.q_type == "checkbox") if @@question_valid_status == true
  end

  def check_question_is_for_valid_user
    self.errors.add(:base, "can't add question for admin") if self.role.name == "admin"
  end

  def check_valid_question_id
    unless self.question_type
      @@question_valid_status = false
    end
  end
end