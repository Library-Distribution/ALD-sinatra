require 'rake'

task 'db:setup' do
  require 'active_record'
  require 'pg'

  create = ENV['DB_SETUP']
  if create.nil?
    print "Is PostgreSQL already setup? Including user, password and (empty) database? [y/n] "
    answer = $stdin.gets.chomp.downcase
    case answer
      when 'y'
        create = false
      when 'n'
        create = true
      else
        puts "Incorrect input. Terminate..."
        exit
    end
  end

  db_setup = {
    :adapter => 'postgresql',
    :host => ENV['DB_HOST'] || 'localhost',
    :port => ENV['DB_PORT'] || '5432'
  }

  %w[user password database].each do |k|
    var = "DB_#{k.upcase}"
    if ENV[var].nil?
      print "\tEnter PostgreSQL #{k}: "
      db_setup[k.to_sym] = $stdin.gets.chomp
    else
      db_setup[k.to_sym] = ENV[var]
      puts "\tUsing PostgreSQL #{k}='#{ENV[var]}'..."
    end
  end

  if create
    puts "\nCreating PostgreSQL user. Enter sudo password if asked to."
    sh "sudo -u postgres psql -c \"CREATE USER #{db_setup[:user]} WITH PASSWORD '#{db_setup[:password]}'\""
    puts "Creating database. Enter sudo password for 'postgres' if asked to."
    sh "sudo -u postgres createdb -O #{db_setup[:user]} #{db_setup[:database]}"
  end

  begin
    ActiveRecord::Base.establish_connection(db_setup)
    require './database/schema.rb'
  rescue PG::Error => e
    puts "Database setup failed. Exiting..."
    exit
  end

  puts "\nCreating foreman .env file..."
  File.open('.env', 'w') do |file|
    file.write("DATABASE_URL=postgres://#{db_setup[:user]}:#{db_setup[:password]}@#{db_setup[:host]}:#{db_setup[:port]}/#{db_setup[:database]}")
  end

  puts "\nDONE! Run app with 'foreman start'."
end