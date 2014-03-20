# ALD-sinatra

[![Coverage Status](https://coveralls.io/repos/Library-Distribution/ALD-sinatra/badge.png?branch=master)](https://coveralls.io/r/Library-Distribution/ALD-sinatra?branch=master)
[![Build Status](https://travis-ci.org/Library-Distribution/ALD-sinatra.png?branch=master)](https://travis-ci.org/Library-Distribution/ALD-sinatra)
[![Code Climate](https://codeclimate.com/github/Library-Distribution/ALD-sinatra.png)](https://codeclimate.com/github/Library-Distribution/ALD-sinatra)
[![Gemnasium](https://gemnasium.com/Library-Distribution/ALD-sinatra.png)](https://gemnasium.com/Library-Distribution/ALD-sinatra)

## About
An incomplete implementation of an ALD server, based on Ruby and Sinatra. It runs on a Heroku server at <http://libba.herokuapp.com>.

## Dependencies
* [Sinatra](http://www.sinatrarb.com/), running on [Thin](http://code.macournoyer.com/thin/)
* [ActiveRecord](https://rubygems.org/gems/activerecord), [pg](https://bitbucket.org/ged/ruby-pg/wiki/Home) and [ar_pg_array](https://github.com/funny-falcon/activerecord-postgresql-arrays), for database access
* [Liquid](http://liquidmarkup.org/) and [Haml](http://haml.info/) templating engines
* [ALD](https://github.com/Library-Distribution/ALD.rb) for package analysis

### Tests
* [rack-test](https://rubygems.org/gems/activerecord)

### Development
* [foreman](https://github.com/ddollar/foreman)

### Ruby
ALD-sinatra is developed, tested and deployed on Ruby 2.0.0. Earlier versions will very likely fail.

## Installation and Setup
Follow these simple steps:
```sh
# Make sure you run Ruby >= 2.0.0, e.g. with:
# rvm use 2.0.0

git clone https://github.com/Library-Distribution/ALD-sinatra.git # clone the repo

cd ALD-sinatra
bundle install # install dependencies

# Make sure postgreSQL 9.3+ is installed.
# See the instructions on <http://www.postgresql.org/download/>

rake db:setup # configure database etc.
# To automate this step, run: [sudo] rake db:setup DB_SETUP=true DB_USER=<user> DB_PASSWORD=<password> DB_DATABASE=<name> [DB_PORT=<port> DB_HOST=<host>]
# User, password and database can be set interactively. If you want to change the port (defaults to 5432) or the host (defaults to localhost), you must set it as seen above.

foreman start # start the app
```

To test if all is well, open your browser and go to `localhost:5000/version` (or whatever port foreman tells you) and see if you get the server version.

## Contributions
Any pull requests or issue reports are welcome.