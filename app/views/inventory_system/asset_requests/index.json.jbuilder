json.requests @asset_requests do |asset_request|
  json.request_id asset_request.id
  json.user_name "#{asset_request.user.f_name} #{asset_request.user.l_name}" if @admin
  if asset_request.request_type == 'allocation'
    json.asset asset_request.asset&.name
  else
    json.asset_item "#{asset_request.asset_item.asset.name} #{asset_request.asset_item.asset_count}"
  end
  json.request_type asset_request.request_type
  json.request_user_reason asset_request.comment_by_user
  json.request_admin_reason asset_request.comment_by_admin unless @admin
  json.status asset_request.status unless @admin
end
