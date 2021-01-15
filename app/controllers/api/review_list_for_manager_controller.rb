class Api::ReviewListForManagerController < ApplicationController
  skip_load_and_authorize_resource
  
  before_action :validate_role

  def index
    review = review = Review.present_quater_reviews(current_quarter)
    render json:review.as_json
  end

  private
    def validate_role
      render :json => {:message=> "Not authorised"} unless current_user.current_role == "manager"
    end
end
