get '/users/list' do
  users = restrict(User.all)
  format(:"users/list", "users" => users)
end

get %r{/users/describe/([0-9a-fA-F]{32})} do |id|
  user = User.find(id)
  describe_user user
end

get %r{/users/describe/(.+)} do |name|
  user = User.find_by_name(name)
  describe_user user
end