# Run the app with `ruby app.rb`

require 'rubygems'
require 'sinatra'
require 'haml'
require 'dm-core'
require 'dm-migrations'
require 'digest/sha1'
require 'sinatra-authentication'
DataMapper.setup(:default, "#{ENV["CLEARDB_DATABASE_URL"]}/#{ENV["CLEARDB_DATABASE_NAME"]}?reconnect=true")
DataMapper.auto_upgrade!
use Rack::Session::Cookie, :secret => "#{ENV["CACHE_SECRET"]}"

get '/' do
  if current_user.admin?
    haml :index
  else
    #redirect '/login'
  end
end
