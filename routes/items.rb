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

  format(:"items/list", "items" => hash(items))
end