# Run the app with `ruby app.rb`

require 'rubygems'
require 'sinatra'
require 'tilt/haml'
require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'
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
    # Construct a unique token URL based on password hash and salt
    @base = request.url
    @url = "users/#{current_user.id}/#{current_user.hashed_password}#{current_user.salt}"

    # Count the number of routes this user has added to the database
    @count = Route.count(:user => current_user.id)

    # Render the view
    haml :index, :locals => {:base => @base, :url => @url, :count => @count}
  else
    redirect '/login'
  end
end

# Upload a new route to the database
post '/users/:id/:token' do
  # Get the record for the specified user
  @user = DmUser.get(params['id'])

  # Does the token match the specified user's password hash and salt?
  if params['token'] == "#{@user.hashed_password}#{@user.salt}"
    Route.create(
      :user => params['id'],
      :points => request.body.read,
      :created_at => Time.now
    )
  end
end
