require 'thor'
require 'yaml'
require_relative 'constants'

module FoodtruckFinder
  # SubCommand to save application token to config file
  class Configure < Thor
    include Constants

    desc "token [token_key]", "Token registered at http://dev.socrata.com/register"
    def token(token_key)
      current_config = {}
      if File.exist?(CONFIG_FILE)
        current_config = ::YAML::load_file(CONFIG_FILE)
      end
      current_config["token"] = token_key

      File.write(CONFIG_FILE, current_config.to_yaml)
      say "Token saved at: #{CONFIG_FILE}", :green
    end
  end
end
