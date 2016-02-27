# Run the app with `ruby app.rb`

require 'rubygems'
require 'sinatra'
require 'tilt/haml'
require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'
require 'digest/sha1'
require 'sinatra-authentication'
require 'json'

# Definition for the route table
require './models/route'

# Connect to our MySQL database
DataMapper.setup(:default, "#{ENV["CLEARDB_DATABASE_URL"]}/#{ENV["CLEARDB_DATABASE_NAME"]}?reconnect=true")
DataMapper.auto_upgrade!

# Configure the session cookie
use Rack::Session::Cookie, :secret => "#{ENV["CACHE_SECRET"]}"

get '/' do
  login_required

  # Has user been deleted?
  if current_user == nil
    redirect '/logout'
  end

  # Construct a unique token URL based on password hash and salt
  @base = request.url
  @url = "users/#{current_user.id}/#{current_user.hashed_password}#{current_user.salt}"

  # Your routes
  @yours = Route.count(:user => current_user.id)

  # All routes (admin-only)
  if current_user.admin?
    @all = Route.count()
  end

  # Render the view
  haml :index, :locals => {:base => @base, :url => @url, :yours => @yours, :all => @all}
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

# Download all routes associated with a user
get '/users/:id/routes.json', :provides => :json do
  login_required
  content_type :json

  if current_user.admin? || current_user.id == params['id'].to_i
    routes = Route.all(:user => params['id']).map do |r|
      JSON.parse(r.points)
    end
    routes.to_json
  else
    status 404
  end
end

# Download all routes in the database (admins-only)
get '/routes.json', :provides => :json do
  login_required
  content_type :json

  if current_user.admin?
    routes = Route.all().map do |r|
      JSON.parse(r.points)
    end
    routes.to_json
  else
    status 404
  end
end
