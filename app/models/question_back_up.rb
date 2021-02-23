class QuestionBackUp < ApplicationRecord
  has_many :answer_back_up, :dependent => :delete_all
end
