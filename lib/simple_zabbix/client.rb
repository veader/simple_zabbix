require 'json'
require 'net/http'

class SimpleZabbix
  class Client
    attr_accessor :auth_hash, :url, :debug_mode, :last_error

    def initialize(url=nil,username=nil,password=nil)
      self.debug_mode = false
      self.url = url unless url.nil?
      authenticate(username, password) unless username.nil? || password.nil?
    end

    def authenticated?
      ! self.auth_hash.nil?
    end

    # returns boolean status of
    def authenticate(username, password)
      results, errors = \
        query_api('user.authenticate', user: username, password: password)

      self.last_error = errors
      self.auth_hash  = results

      errors.nil? # only successful without errors
    end

    def url=(the_url)
      @url = the_url
      # make sure it is a complete url with proper path
      @url = 'http://' + @url unless @url.match(/^http[s]*\:\/\//)
      unless @url.match(/jsonrpc/)
        @url += '/' unless @url.match(/\/$/)
        @url += 'api_jsonrpc.php'
      end
    end

    def api_version
      @_api_version ||= query_api('apiinfo.version').first
    end

    def query_api(method, params={})
      json_request  = create_json_request(method, params)
      json_response = make_http_request(json_request)

      parse_json_response(json_response, json_request)
    end

  protected # ---------------------------------------------------------------
    def make_http_request(json_request)
      uri = URI.parse(self.url)

      http = Net::HTTP.new(uri.host, uri.port)
      if uri.port == 443
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field('Content-Type', 'application/json-rpc')
      request.body = json_request
      response = http.request(request)

      raise "HTTP Error: #{response.code} on #{self.url}" if response.code != '200'

      puts response.body if self.debug_mode
      response.body
    end

    def create_json_request(method, params)
      message = {
        method:  method,
        params:  params,
        auth:    self.auth_hash,
        id:      rand(100000),
        jsonrpc: '2.0',
      }
      JSON.generate(message)
    end

    # NOTE returns a tuple of (result, error)
    def parse_json_response(response, request)
      results = JSON.parse(response)

      [results['result'], results['error']]
    end

  end # Client

end # SimpleZabbix
