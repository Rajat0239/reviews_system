class Api::ReviewListForManagerController < ApplicationController
  
  skip_load_and_authorize_resource

  before_action :validate_role

  def index
    review = Review.joins(:user).select("users.reporting_user_id,users.f_name, reviews.ratings, reviews.feedback, reviews.user_id, reviews.status")
    render json: review
  end

  private
  
    def validate_role
      render :json => {:message=> "Not authorised"} unless current_user.current_role == "manager"
    end
    
end
