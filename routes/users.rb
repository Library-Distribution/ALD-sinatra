get '/users/?' do
  users = restrict(User.all)
  format(:"users/list", "users" => users)
end

get %r{/users/([0-9a-fA-F]{32})} do |id|
  user = User.find(id)
  halt 404 if user.nil?

  describe_user user
end

get '/users/:name' do |name|
  user = User.find_by_name(name)
  halt 404 if user.nil?

  describe_user user
end