require 'data_mapper'
class User
  include DataMapper::Resource

  property :id, Serial
  property :user_id, String, :unique_index => :unique_user
end
