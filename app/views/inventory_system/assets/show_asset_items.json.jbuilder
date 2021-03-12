json.asset_id @asset.id
json.name @asset.name
json.asset_fields @asset.asset_fields do |asset_field|
  json.asset_field_id asset_field.id
  json.asset_field_name asset_field.field
end

json.asset_items @asset.asset_items do |asset_item|
  json.asset_item_id asset_item.id
  json.asset_item_name @asset.name + " " + asset_item.asset_count.to_s
  json.asset_item_values_with_fields asset_item.asset_item_values do |asset_item_value|
    json.asset_item_value_id asset_item_value.id
    json.asset_field_value asset_item_value.value
  end
end