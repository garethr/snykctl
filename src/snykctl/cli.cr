require "commander"
require "json"
require "../snyk"

module SnykCtl::CLI
  extend self

  def client(debug : Bool = false)
    token = ENV["SNYK_TOKEN"]
    Snyk::Client.new(token, logging: debug)
  rescue KeyError
    puts "Missing SNYK_TOKEN environment variable"
    exit 2
  end

  def config
    Commander::Command.new do |cmd|
      cmd.use = "snykctl"
      cmd.long = "Command line tool for interacting with the Snyk API"

      cmd.run do |_, _|
        puts cmd.help
      end

      cmd.commands.add do |api|
        api.use = "api [path ...]"
        api.short = "Make Snyk API requests and print raw responses"
        api.long = cmd.short
        api.run do |options, arguments|
          path = arguments.join("/")
          data_or_file = options.string["data"]
          data = File.file?(data_or_file) ? File.read(data_or_file) : data_or_file
          begin
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
            puts response.body
          rescue ex : Snyk::APIError
            puts ex.message
            exit 2
          end
        end

        api.flags.add do |flag|
          flag.name = "method"
          flag.short = "-m"
          flag.long = "--method"
          flag.default = "get"
          flag.description = "The HTTP method to use for the API call"
        end

        api.flags.add do |flag|
          flag.name = "data"
          flag.long = "--data"
          flag.default = ""
          flag.description = "Data to pass to the API"
        end

        api.flags.add do |flag|
          flag.name = "debug"
          flag.short = "-d"
          flag.long = "--debug"
          flag.default = false
          flag.description = "Whether or not to show HTTP debugging info"
        end
      end
    end
  end

  def run(argv)
    Commander.run(config, argv)
  end
end
