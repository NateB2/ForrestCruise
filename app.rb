# Run the app with `ruby app.rb`

require 'rubygems'
require 'sinatra'
require 'haml'
require 'dm-core'
require 'dm-migrations'
require 'digest/sha1'
require 'sinatra-authentication'
DataMapper.setup(:default, "#{ENV["CLEARDB_DATABASE_URL"]}/forrest")
DataMapper.auto_upgrade!
use Rack::Session::Cookie, :secret => 'ENV["CACHE_SECRET"]'
