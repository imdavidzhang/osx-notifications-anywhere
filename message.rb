require 'data_mapper'
class Message
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :subtext, String
  property :body, Text
  property :group, String
  property :created_at, DateTime

  belongs_to :user
end
