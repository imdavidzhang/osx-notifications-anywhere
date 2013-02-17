require 'data_mapper'
require './user'
class Message
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :subtext, String
  property :body, Text
  property :group, String
  property :created_at, DateTime
  property :status, String

  belongs_to :user, :key => true
end
