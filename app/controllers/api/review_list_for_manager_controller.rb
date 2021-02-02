class Api::ReviewListForManagerController < ApplicationController
  
  skip_load_and_authorize_resource

  before_action :validate_role

  def index
    @review = Review.joins(:user).where("users.reporting_user_id = ?", current_user.id).select("reviews.id, reviews.user_id, reviews.ratings, reviews.feedback, reviews.status, users.f_name, users.l_name , reviews.created_at, reviews.updated_at")
    render json: @review.as_json
  end

  private
  
    def validate_role
      render :json => {:message=> "Not authorised"} unless current_user.current_role == "manager"
    end
    
end
