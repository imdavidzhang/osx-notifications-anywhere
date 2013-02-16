require 'net/http'

HOST='http://ona.herokuapp.com/get'
SLEEP=5


url = URI.parse(HOST)
req = Net::HTTP::Get.new(url.to_s)

loop do
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  puts res.body
  puts "a"
  sleep(SLEEP)
end
