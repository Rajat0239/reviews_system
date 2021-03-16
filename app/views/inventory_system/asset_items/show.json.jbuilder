json.asset_item do
  json.id @asset_item.id
  json.asset_id @asset_item.asset_id
  json.name "#{@asset_item.asset.name} #{@asset_item.asset_count}"
end
@asset_item_values = @asset_item.asset_item_values
json.asset_item_field_and_values @asset_item.asset.asset_fields do |asset_item_field|
  @asset_item_value = @asset_item_values.find_by(asset_field_id: asset_item_field.id)
  json.id @asset_item_value&.id
  json.field asset_item_field.field
  json.asset_field_id asset_item_field.id
  json.value @asset_item_value&.value
end
