get '/items/list' do

  items = Item.where(
    conditions(
      :exact => %i[name downloads rating],
      :range => %i[downloads rating], # :version
      :array => [:tags]
      # :version (latest, first)
      # :reviewed :stable (switch)
    )
  ).order(
    sort(%i[name version uploaded downloads rating])
  )

  items = restrict(items) # offset and limit

  format(:"items/list", "items" => items)
end

get %r{/items/describe/([0-9a-fA-F]{32})} do |id|
  item = Item.find(id)
  halt 404 if item.nil?

  format :'items/describe', 'item' => item
end

get '/items/describe/:name/:version' do |name, version|
  if ['latest', 'first'].include? version
    # todo
  else
    item = Item.find_by name: name, version: version
  end
  halt 404 if item.nil?

  format :'items/describe', 'item' => item
end