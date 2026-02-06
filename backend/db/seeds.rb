User.find_or_create_by!(email: "staff@test.com") do |u|
  u.password = "password"
  u.role = "staff"
end

