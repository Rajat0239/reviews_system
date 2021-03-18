class InventorySystem::AssetRequestsController < ApplicationController
  # before_action :check_params, only: [:create]

  def index
    @admin = role_is_admin
    if @admin
      @asset_requests = AssetRequest.where(status: 'pending')
    else
      @asset_requests = current_user.asset_requests
    end
  end

  def create
    @asset_request = current_user.asset_requests.new(request_params)
    if @asset_request.save
      success_response('request submitted')
    else
      faliure_response(@asset_request.errors.full_messages)
    end
  end

  def update
    if params[:request_data][:status] == "rejected"
      update_request_to_rejected
    elsif params[:request_data][:status] == "approved"
      perform_allocation_or_deallocation
    else
      faliure_response('invalid request status')
    end
  end

  def destroy
    @asset_request.destroy
    success_response('request deleted')
  end
  
  private

  def request_params
    params.require(:request_data).permit(:asset_id, :asset_item_id, :comment_by_user, :request_type, :comment_by_admin, :status)
  end

  def update_request_to_rejected
    if @asset_request.update(request_params)
      success_response('request rejcted')
    else
      faliure_response(@asset_request.errors.full_messages)
    end
  end

  def perform_allocation_or_deallocation
    if @asset_request.request_type == 'deallocation' && @asset_request.asset_item.update(user_id: nil)
      update_request_to_approved
      success_response('asset deallocated successfully')
    else
      byebug
    end
  end

  def update_request_to_approved
    @asset_request.update(request_params)
  end

  # def check_params
  #   byebug
  # end
end
