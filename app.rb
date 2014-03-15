#! ruby

require 'sinatra'
use Rack::Reloader

require 'active_record'
require 'pg'

require 'haml'
require 'liquid'
require './liquid'

require 'yaml'

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

ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))

module ALD
  VERSION = '0.0.0'

  OUTPUT_TYPES = %w[text/xml application/xml application/json]
end