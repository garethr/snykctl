require "crest"

module Snyk
  class Client
    API_URL = "https://snyk.io/api/v1"

    def initialize(@token : String, @url : String = API_URL, @logging : Bool = false)
    end

    def url
      @url
    end

    def headers
      {
        "Authorization" => "token #{@token}",
        "User-Agent"    => "snyk.cr/#{Snyk::VERSION}",
        "Content-Type"  => "application/json; charset=utf-8",
      }
    end

    def get(path : String)
      Crest.get(
        "#{@url}/#{path}",
        headers: headers,
        logging: @logging
      )
    rescue ex : Crest::RequestFailed
      raise APIError.new(response: ex.response)
    end

    def delete(path : String)
      Crest.delete(
        "#{@url}/#{path}",
        headers: headers,
        logging: @logging
      )
    rescue ex : Crest::RequestFailed
      raise APIError.new(response: ex.response)
    end

    def put(path : String, data : String)
      Crest.put(
        "#{@url}/#{path}",
        headers: headers,
        form: data,
        logging: @logging
      )
    rescue ex : Crest::RequestFailed
      raise APIError.new(response: ex.response)
    end

    def post(path : String, data : String)
      Crest.post(
        "#{@url}/#{path}",
        headers: headers,
        form: data,
        logging: @logging
      )
    rescue ex : Crest::RequestFailed
      raise APIError.new(response: ex.response)
    end
  end

  class Error < Exception
  end

  class APIError < Crest::RequestFailed
  end
end
