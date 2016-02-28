class Route
  include DataMapper::Resource

  property :id, Serial
  property :user, String
  property :points, Text
  property :created_at, DateTime
end
