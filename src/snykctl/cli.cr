require "commander"
require "json"
require "../snyk"
require "./api"

module SnykCtl::CLI
  extend self

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
          begin
            puts SnykCtl::API.run(options, arguments)
          rescue ex : Snyk::APIError
            puts ex.message
            exit 1
          rescue ex : SnykCtl::API::Error
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
