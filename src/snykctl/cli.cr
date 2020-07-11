require "commander"
require "../snyk"

module SnykCtl::CLI
  extend self

  def client
    begin
      Snyk::Client.new
    rescue ex : Snyk::Error
      print ex.message
      exit 2
    end
  end

  def config
    Commander::Command.new do |cmd|
      cmd.use = "snykls"
      cmd.long = "Command line tool for interacting with the Snyk API"

      cmd.run do |options, arguments|
        puts cmd.help
      end

      cmd.commands.add do |cmd|
        cmd.use = "api [path ...]"
        cmd.short = "Make Snyk API requests and print raw responses"
        cmd.long = cmd.short
        cmd.run do |options, arguments|
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
