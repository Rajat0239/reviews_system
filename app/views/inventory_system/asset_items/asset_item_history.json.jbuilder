json.current_user @asset_item.user ? "#{@asset_item.user.f_name} #{@asset_item.user.l_name}" : 'free'
json.users @asset_item.asset_tracks do |asset_track|
  json.name "#{asset_track.user.f_name} #{asset_track.user.l_name}"
  json.assigned_on asset_track.assigned_on
  json.submitted_on asset_track.submitted_on || 'on use'
end
