class Question < ApplicationRecord

  @@question_valid_status = true

  validate :check_valid_question_id, :set_options_nill_if_q_type_is_feedback, :on => [:create]
  validates :question, presence: true
  validates :question, uniqueness: { scope: [:question], message: 'has already created !' }
  validates :options, presence: true, if: :if_options_are?

  belongs_to :question_type
  has_many :reviews
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
end