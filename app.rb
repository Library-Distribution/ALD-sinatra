#! ruby

require 'sinatra'
use Rack::Reloader

require 'active_record'
require 'pg'

require 'haml'
require 'liquid'
require './liquid'

require 'uri'
require 'digest/md5'

require './filters'
require './helpers'
require './models'

require './routes/general'
require './routes/items'
#require './routes/items/review'
require './routes/users'
#require './routes/users/registration'
#require './routes/users/suspension'
#require './routes/stdlib'
#require './routes/stdlib/releases'
#require './routes/stdlib/candidates'
#require './routes/stdlib/pending'

uri = URI.parse(ENV["DATABASE_URL"])
ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :database => (uri.path || "").split("/")[1],
  :username => uri.user,
  :password => uri.password,
  :host     => uri.host,
  :port     => uri.port
)

module ALD
  VERSION = '0.0.0'

  OUTPUT_TYPES = %w[text/xml application/xml application/json]
end