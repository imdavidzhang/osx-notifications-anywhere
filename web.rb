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

post '/put' do
  connect
  user = User.first(:user_id => params[:user])
  unless user.nil?
    msg = Message.new(:title => params[:title],
                      :subtext => params[:subtext],
                      :group => params[:group],
                      :body => params[:message],
                      :user_id => user.id,
                      :status => 0)
    if(msg.save)
      return {:message => '', :success => true}.to_json
    else
      return {:message => 'save failed'}.to_json
    end
  end
end

get '/get' do
  connect
  user = User.first(:user_id => params[:user])
  range = params[:last_message_id] || -1

  unless user.nil?
    token = user.id
    
    messages = Message.all(:user_id => token, :id.gt => range)
    return messages.to_json
  end

  return { 'message' => 'token not found' }.to_json
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
      return {:token => random_str, :message => ""}.to_json if user.save
    end
    tries -= 1
  end
  "no"
end
