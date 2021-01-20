class Question < ApplicationRecord

  belongs_to :role
  has_many :reviews

  validates :question, :role_id, presence: true 
  validates_uniqueness_of :question, :scope => [:question, :role_id]

end
