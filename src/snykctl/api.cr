require "commander"
require "json"
require "../snyk"

module SnykCtl::API
  extend self

  class Error < Exception
  end

  def client(debug : Bool = false)
    token = ENV["SNYK_TOKEN"]
    Snyk::Client.new(token, logging: debug)
  rescue KeyError
    raise Error.new("Missing SNYK_TOKEN environment variable")
  end

  def run(options, arguments)
    path = arguments.join("/")
    data_or_file = options.string["data"]
    data = File.file?(data_or_file) ? File.read(data_or_file) : data_or_file
    c = client(options.bool["debug"])
    response = case options.string["method"].downcase
               when "get"
                 c.get(path)
               when "post"
                 c.post(path, data)
               when "put"
                 c.put(path, data)
               when "delete"
                 c.delete(path)
               else
                 puts "Method must be GET, POST, PUT or DELETE"
                 exit 2
               end
    response.body
  end
end
