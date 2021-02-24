class QuestionType < ApplicationRecord
  
  validates :q_type, presence: true
  
  has_many :question_backups
  has_many :questions

end
