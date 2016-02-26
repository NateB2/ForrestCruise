# Run the app with `ruby app.rb`

require 'rubygems'
require 'sinatra'
require 'tilt/haml'
require 'dm-core'
require 'dm-migrations'
require 'digest/sha1'
require 'sinatra-authentication'

# Definition for the route table
require_relative 'models/route'

# Connect to our MySQL database
DataMapper.setup(:default, "#{ENV["CLEARDB_DATABASE_URL"]}/#{ENV["CLEARDB_DATABASE_NAME"]}?reconnect=true")
DataMapper.auto_upgrade!

# Configure the session cookie
use Rack::Session::Cookie, :secret => "#{ENV["CACHE_SECRET"]}"

get '/' do
  if logged_in?
    @url = "/users/#{current_user.id}/#{current_user.hashed_password}#{current_user.salt}"
    haml :index, :locals => {:url => @url}
  else
    redirect '/login'
  end
end

post '/users/:id/:token' do
  @user = DmUser.get(params['id'])
  if params['token'] == "#{@user.hashed_password}#{@user.salt}"
    Route.create(
      :user => params['id'],
      :points => request.body.read,
      :created_at => Time.now
    )
  end
end
