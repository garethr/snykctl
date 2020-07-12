require "commander"
require "../snyk"

module SnykCtl::CLI
  extend self

  def client
    Snyk::Client.new
  rescue ex : Snyk::Error
    print ex.message
    exit 2
  end

  def config
    Commander::Command.new do |cmd|
      cmd.use = "snykls"
      cmd.long = "Command line tool for interacting with the Snyk API"

      cmd.run do |_, _|
        puts cmd.help
      end

      cmd.commands.add do |api|
        api.use = "api [path ...]"
        api.short = "Make Snyk API requests and print raw responses"
        api.long = cmd.short
        api.run do |_, arguments|
          begin
            response = client.get(arguments.join("/"))
            puts response.body
          rescue ex : Snyk::APIError
            puts ex.message
          end
        end
      end
    end
  end

  def run(argv)
    Commander.run(config, argv)
  end
end
