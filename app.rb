# Run the app with `ruby app.rb`

require 'rubygems'
require 'sinatra'
#require 'sinatra-authentication'
require 'haml'
require 'couchrest'
require 'json'

get '/' do
  db = CouchRest.database("#{ENV['CLOUDANT_URL']}/users")

  mydoc = { :username => 'djsauble', :password => 'passw0rd' }

  db.save_doc(mydoc)

  "Success!"
end
