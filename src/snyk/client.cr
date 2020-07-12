require "crest"

module Snyk
  class Client
    @token : String
    API_URL = "https://snyk.io/api/v1"

    def initialize(@url : String = API_URL)
      begin
        token = ENV["SNYK_TOKEN"]
      rescue KeyError
        raise Error.new "Missing SNYK_TOKEN"
      end
      @token = token
    end

    def url
      @url
    end

    def get(path : String)
      Crest.get(
        "#{@url}/#{path}",
        headers: {
          "Authorization" => "token #{@token}",
          "User-Agent"    => "snyk.cr/#{Snyk::VERSION}",
          "Content-Type"  => "application/json",
        }
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
