get '/items/?' do

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

post '/items/?' do
  authorize!
  halt 415 unless request.media_type == 'application/x-ald-package'

  tmp = Tempfile.new('upload')
  begin
    request.body.rewind
    tmp.write request.body.read

    package = nil
    begin
      package = ALD::Package.open(tmp.path)
    rescue ALD::InvalidPackageError, ALD::InvalidDefinitionError
      halt 400
    end

    halt 400 unless ALD::ITEM_TYPES.include?(package.definition.type)

    halt 409 if Item.exists?(package.definition.id) ||
                Item.exists?(name: package.definition.name, version: package.definition.version) # check if it already exists

    halt 403 if Item.exists?(name: package.definition.name) &&
                Item.find(name: package.definition.name).any? { |i| i.user.name != authorization.credentials[0] } # other users must not claim this item

    User.find(authorization.credentials[0]).items.create( # user should always be found as otherwise authorization would fail
      id:          IdRecord.unhex(package.definition.id),
      name:        package.definition.name,
      version:     package.definition.version,
      # authors
      item_type:   package.definition.type, # existence ensured by check above
      description: package.definition.description,
      tags:        package.definition.tags
    )

    # store in file system / cloud
  ensure
    tmp.close
    tmp.unlink
  end
end

get %r{/items/([0-9a-fA-F]{32})} do |id|
  item = Item.find(id)
  halt 404 if item.nil?

  format :'items/describe', 'item' => item
end

get '/items/:name/:version' do |name, version|
  if ['latest', 'first'].include? version
    # todo
  else
    item = Item.find_by name: name, version: version
  end
  halt 404 if item.nil?

  format :'items/describe', 'item' => item
end