class QuestionType < ApplicationRecord
  
  validates :type, presence: true

  has_many :questions

end
