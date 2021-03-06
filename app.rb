#! ruby

require 'sinatra'
require 'active_record'
require 'pg'
require 'haml'
require 'liquid'
require 'ALD'

require 'uri'
require 'digest/md5'
require 'digest/sha2'
require 'tempfile'

def require_dir(path)
  Dir["#{File.dirname(__FILE__)}/#{path}/*.rb"].each { |file| require(file) }
end

require './liquid'
require './filters'
require './models'

require_dir 'helpers'
require_dir 'routes'

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

  ITEM_TYPES = %w[lib app]
end