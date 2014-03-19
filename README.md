# ALD-sinatra

[![Coverage Status](https://coveralls.io/repos/Library-Distribution/ALD-sinatra/badge.png?branch=master)](https://coveralls.io/r/Library-Distribution/ALD-sinatra?branch=master)
[![Build Status](https://travis-ci.org/Library-Distribution/ALD-sinatra.png?branch=master)](https://travis-ci.org/Library-Distribution/ALD-sinatra)
[![Code Climate](https://codeclimate.com/github/Library-Distribution/ALD-sinatra.png)](https://codeclimate.com/github/Library-Distribution/ALD-sinatra)
[![Gemnasium](https://gemnasium.com/Library-Distribution/ALD-sinatra.png)](https://gemnasium.com/Library-Distribution/ALD-sinatra)

## About
An incomplete implementation of an ALD server, based on Ruby and Sinatra. It runs on a Heroku server at <http://libba.herokuapp.com>.

## Dependencies
* [Sinatra](http://www.sinatrarb.com/), running on [Thin](http://code.macournoyer.com/thin/)
* [ActiveRecord](https://rubygems.org/gems/activerecord) and [pg](https://bitbucket.org/ged/ruby-pg/wiki/Home), for database access
* [Liquid](http://liquidmarkup.org/) and [Haml](http://haml.info/) templating engines
* [ALD](https://github.com/Library-Distribution/ALD.rb) for package analysis

### Tests
* [rack-test](https://rubygems.org/gems/activerecord)

### Development
* [foreman](https://github.com/ddollar/foreman)

## Installation
Download or `git clone` the repository. Open the console and navigate to it, then run `bundle install`.

You must also have a PostgreSQL database with several tables. Those are not yet documented as they're subject to frequent change at this stage.

## Setup
To run the server successfully, you must first configure an environment variable called `DATABASE_URL`
in the form of `DATABASE_URL=postgres://<user>:<password>@<host>:<port>/<DB>` to point to your
PostgreSQL database. (You can do this via a foreman `.env` file.)

Then just run `foreman start`.

To test if all is well, open your browser and go to `localhost:5000/items` (or whatever port foreman tells you) and see if you get an (initially empty)
list of items (in XML or JSON, depending on your browser configuration).

## Contributions
Any pull requests or issue reports are welcome.