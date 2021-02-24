class QuestionBackup < ApplicationRecord
  belongs_to :question
  belongs_to :question_type
end
