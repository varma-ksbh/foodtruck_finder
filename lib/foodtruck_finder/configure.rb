require 'thor'
require 'yaml'
require_relative 'constants'

module FoodtruckFinder
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
      puts "Token saved at: #{CONFIG_FILE}"
    end
  end
end
