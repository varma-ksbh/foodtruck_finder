require 'thor'

require_relative 'configure'
require_relative 'foodtruck_finder/version'
require_relative 'foodtruck_finder/dao'
require_relative 'foodtruck_finder/model'

module FoodtruckFinder
  class Error < StandardError; end
  class CLI < Thor
    class_option :token, type: :string, desc: :"Token registered at http://dev.socrata.com/register" 

    def initialize(args = [], local_options = {}, config = {})
      super(args, local_options, config)
      load_configs!
    end

    desc "foodtruck [truck_identifier]", "returns the food truck with the identifier"
    def foodtruck(identifier)
      foodtruck_dao = FoodtruckDao.new
      foodtruck_hash = foodtruck_dao.get_foodtruck(identifier)
      foodtruck = Foodtruck.new(foodtruck_hash)
      puts foodtruck.name
    end

    desc "configure", "provide configuration"
    subcommand "configure", Configure

    private ###############################

    def load_configs!
      
      puts options
      puts __dir__
      
      return options unless File.file?(".foodtruckfinder")
      defaults = ::YAML::load_file(".foodtruckfinder") || {}
      puts 'defaulttt'
      puts defaults
      puts 'defaulttt'
      # Foreman::Thor::CoreExt::HashWithIndifferentAccess.new(defaults.merge(original_options))
    end
  end
end
