json.user_asste_list @user.asset_items do |asset_item|
  json.id asset_item.id
  json.name "#{asset_item.asset.name} #{asset_item.asset_count}"
end