require 'net/http'
def make_request(url, flags, method=:post)
  begin
    url = URI.parse(url)

    if(method == :post)
      req = Net::HTTP::Post.new(url.to_s)
      req.set_form_data(flags)
    else
      full_url = url.to_s + '?' + flags.map { |pair| pair[0].to_s + '=' + pair[1].to_s }.join("&")
      puts "full url: #{full_url}"
      req = Net::HTTP::Get.new(full_url)
    end

    res = nil
    Net::HTTP.start(url.host, url.port) do |http|
      res = http.request(req)
    end
    return JSON.parse(res.body)
  rescue => ex
    pp ex
  end
end


