require 'optparse'
require 'json'
require 'pp'
require 'net/http'

def parse_config
  parsed = config_path 
  parsed_options = {}
  begin
    config_text = IO.read(parsed)
    parsed_options = JSON.parse(config_text)
  rescue
  end

  return parsed_options
end

def write_config(config)
  File.open(config_path, 'w+') do |f|
    f.puts(config.to_json)
  end
end

def set_token(resp)
  token = resp['token']
  if(!token.nil?)
    existing_config = parse_config 
    existing_config['token'] = token
    write_config(existing_config)
  end

end

def make_request(url, flags)
  begin
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    
   return JSON.parse(res.body)
  rescue => ex
    puts ex
  end
end

def set_defaults(options)
  options[:url] ||= 'http://ona.herokuapp.com/'
end

def config_path
  "#{File.expand_path('~')}/.ona"
end

options = {}

optparse = OptionParser.new do |opts|
  opts.on('-r', '--register', 'Register token') do
    options[:register] = true
    options[:path] = 'register'
  end
end

optparse.parse!

config = parse_config
set_defaults(config)

if(options[:register])
  if(config['token'] && !config['force'])
    puts "already registered: #{config['token']}"
    exit
  end


  resp = make_request(config[:url] + options[:path], {}) 

  if(!resp.nil?)
    set_token(resp)
  end
end
