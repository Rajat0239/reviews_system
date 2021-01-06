class Api::ReviewDatesController < ApplicationController
  def create
    (ReviewDate.where(quarter: current_quarter))? current : (puts "can update") 
    byebug
  end
end
