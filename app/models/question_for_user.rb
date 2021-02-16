class QuestionForUser < ApplicationRecord

  validates :question_id, uniqueness: { scope: [:question_id, :quarter, :role_id], message: 'You have already add this question for this role in prasent quarter!'}
  belongs_to :role
  belongs_to :question
  has_many :reviews
end
