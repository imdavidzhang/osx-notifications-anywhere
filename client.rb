require 'optparse'
require 'json'
require 'pp'
require 'net/http'
require './osa_config'
require './request'
require 'terminal-notifier'

def process(config, options)
  resp = make_request(config.base + 'get', {:user => config.token, :last_message_id => config.last_message_id}, :get)
  highest_resp = resp.max_by { |x| x['id'] }

  if highest_resp 
    processed = resp.max_by do |msg|
      TerminalNotifier.notify(msg['body'], :title => msg['title'], 
                              :subtitle => msg['subtext'],
                              :group => msg['group'])
      msg['id'].to_i
    end

    if !options[:debug]
      highest_id = highest_resp['id']
      config.last_message_id = highest_id 
      config.write
    end
  end
end

options = {}

optparse = OptionParser.new do |opts|
  options[:pull] = true
  opts.on('-r', '--register', 'Register token') do
    options[:register] = true
    options[:path] = 'register'
  end

  opts.on('-d', '--debug', "don't set last message id") do
    options[:debug] = true
  end
end

optparse.parse!

config = OnaConfig.new('pull')

if(options[:register])
  if(config.token)
    puts "already registered: #{config.token}"
    exit
  end

  resp = make_request(config.base + options[:path], {}, :get) 

  pp resp
  if(!resp.nil?)
    puts "registered: #{resp['token']}"
    config.token = resp['token']
    config.write
  end
elsif(options[:pull])
  if(config.token)
    loop do
      process(config, options)
      sleep(5)
    end
  else
    puts "no client token"
  end
end
