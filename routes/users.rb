get '/users/list' do
  users = restrict(User.all)
  format(:"users/list", "users" => hash(users))
end