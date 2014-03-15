get '/version' do
  format(:version, "version" => ALD::VERSION)
end