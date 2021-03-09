json.users  @users do |user|
  json.user_id user.id
  json.user_name user.f_name + " " + user.l_name
end