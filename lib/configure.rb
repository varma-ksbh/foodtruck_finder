require 'thor'
require 'yaml'

module FoodtruckFinder
  class Configure < Thor
    desc "token [token_key]", "Token registered at http://dev.socrata.com/register"
    def token(token_key)
      current_config = {}
      if File.exist?("#{Dir.home}/.foodtruck_finder")
        current_config = ::YAML::load_file("#{Dir.home}/.foodtruck_finder")
      end
      puts current_config
      current_config["token"] = token_key

      File.write("#{Dir.home}/.foodtruck_finder", current_config.to_yaml)
    end
  end
end