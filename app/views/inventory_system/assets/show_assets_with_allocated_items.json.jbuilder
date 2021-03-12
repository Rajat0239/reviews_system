json.allocated_items_assets @assets do |asset|
  json.asset_id asset.id
  json.asset asset.name
  json.allocated_items asset.asset_items do |asset_item|
    if !asset_item.user_id.nil?
      json.asset_item_id asset_item.id
      json.asset_item_name asset.name + " " + asset_item.asset_count.to_s
      json.allocated_to_user asset_item.user.f_name + " " + asset_item.user.l_name
    end
  end
end