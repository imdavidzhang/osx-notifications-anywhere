class OnaConfig
  attr_accessor :token
  attr_accessor :base
  attr_accessor :last_message_id

  def initialize(path)
    @path = File.expand_path("~") + '/.ona_' + path + '.conf'
    @base = 'http://ona.herokuapp.com/'
    parse_config
  end

  def write
    File.open(@path, 'w+') do |f|
      f.puts({'token' => @token, 'last_message_id' => @last_message_id}.to_json)
    end
  end

  private 
  def parse_config
    parsed_options = {}
    begin
      config_text = IO.read(@path)
      parsed_options = JSON.parse(config_text)
      @token = parsed_options['token']
      @last_message_id = parsed_options['last_message_id'] || -1
    rescue
    end
  end
end
