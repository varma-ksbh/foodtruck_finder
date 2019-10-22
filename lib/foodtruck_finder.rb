require 'thor'

require_relative 'foodtruck_finder/configure'
require_relative 'foodtruck_finder/version'
require_relative 'foodtruck_finder/dao'
require_relative 'foodtruck_finder/model'
require_relative 'foodtruck_finder/constants'

module FoodtruckFinder
  class Error < StandardError; end
  class CLI < Thor
    include Constants
    class_option :token, type: :string, desc: :"Token registered at http://dev.socrata.com/register" 

    def initialize(args = [], local_options = {}, config = {})
      super(args, local_options, config)
      load_configs!
      @foodtruck_dao = FoodtruckDao.new(@config['token'])
    end

    desc "configure", "provide configuration"
    long_desc <<-LONGDESC
      You can provide configuration to Foodtruck Finder in 3 ways
      1. By supply command line options i.e --token
      2. By setting Environment variables i.e setenv SOCRATA_TOKEN=abc****
      3. By using configure subcommand i.e configure

    NOTE: The order of precedence is 1 > 2 > 3
    i.e 'Command line Options' take precedence over 'Environment Variables' &
    'Environment Variables' takes precendence over 'Subcommand'
    LONGDESC
    subcommand "configure", Configure

    desc "foodtruck [truck_identifier]", "returns the food truck with the identifier"
    def foodtruck(identifier)
      foodtruck_hash = @foodtruck_dao.get_foodtruck(identifier)
      foodtruck = Foodtruck.new(foodtruck_hash)
      puts foodtruck.name
      ask "Need more records?"
      puts "fuck no more!"
    end

    desc "current_available_foodtrucks", "current available trucks"
    method_option 'page-size', type: :numeric, :default => 10, aliases: :"-n"
    method_option 'starting-token', type: :string, aliases: :"-t"
    def current_available_foodtrucks
      puts 'hey'
    end

    private ###############################

    def load_configs!
      @config = {}
      if File.file?(CONFIG_FILE)
        @config = ::YAML::load_file(CONFIG_FILE)
      end
      
      unless ENV['SOCRATA_TOKEN'].nil?
        @config['token'] = ENV['SOCRATA_TOKEN']
      end

      @config = @config.merge(options) unless options.nil?
    end
  end
end
