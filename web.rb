require 'sinatra'
require 'json'
require 'pg'
require 'data_mapper'
require 'pp'
require './message'
require './user'

def gen(n)
  set = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split("")

  1.upto(n).map { |x| set[rand(set.length)] }.join("").downcase
end

def connect
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  User.auto_upgrade!
  Message.auto_upgrade!
end

get '/put' do
  connect
  "Hello, world2"
end

get '/get' do
  connect
  puts "abcde"
  "Hello, world3"
end

get '/register' do
  content_type :json

  connect
  tries = 10

  response = {}
  1.upto(tries) do
    random_str = gen(10)
    user = User.first(:user_id => random_str)
    unless(!user.nil?)
      user= User.new(:user_id => random_str)
      return random_str if user.save
    end
    tries -= 1
  end
  "no"
end
