require 'optparse'
require 'pp'
require 'json'
require './osa_config'
require './request'
options = {}
optparse = OptionParser.new do |opts|
  opts.on('-u', '--token TOKEN', 'Set token') do |v|
    options[:token] = v 
  end
  opts.on('-t', '--title TITLE', 'Title') do |v|
    options[:title] = v
  end
  opts.on('-s', '--subtext SUB', 'Subtext') do |v|
    options[:subtext] = v
  end
  opts.on('-g', '--group GROUP', 'Group') do |v|
    options[:group] = v
  end
end


optparse.parse!
config = OnaConfig.new('push') 
if(options[:token])
  config.token = options[:token]
  config.write
else
  puts "send"
  token = config.token
  puts "z"
  unless token.nil?
    message = STDIN.read
    options[:message] = message
    options[:title] ||= '(no title)'
    options[:subtext] ||= '(no subtext)'
    options[:group] ||= 'default'
    options[:user] = token

    pp make_request(config.base + 'put', options)
  end
end

