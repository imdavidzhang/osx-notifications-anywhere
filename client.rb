require 'optparse'
require 'json'
require 'pp'
require 'net/http'
require './osa_config'
require './request'

options = {}

optparse = OptionParser.new do |opts|
  options[:pull] = true
  opts.on('-r', '--register', 'Register token') do
    options[:register] = true
    options[:path] = 'register'
  end
end

optparse.parse!

config = OnaConfig.new('pull')

if(options[:register])
  if(config.token)
    puts "already registered: #{config.token}"
    exit
  end

  resp = make_request(config.base + options[:path], {}) 

  if(!resp.nil?)
    puts "registered: #{resp['token']}"
    config.token = resp['token']
    config.write
  end
elsif(options[:pull])
  resp = make_request(config.base + 'get', {:user => config.token, :last_message_id => config.last_message_id}, :get)
  highest_resp = resp.max_by { |x| x['id'] }
  
  unless highest_resp.nil?
    highest_id = highest_resp['id']
    config.last_message_id = highest_id 
    config.write
  end
end
