require 'thor'
require 'fileutils'
require 'terminal-table'

require_relative 'foodtruck_finder/configure'
require_relative 'foodtruck_finder/version'
require_relative 'foodtruck_finder/dao'
require_relative 'foodtruck_finder/constants'

module FoodtruckFinder
  class CLI < Thor
    include Constants
    class_option :token, type: :string, desc: :"Token registered at http://dev.socrata.com/register" 

    def initialize(args = [], local_options = {}, config = {}, foodtruck_dao = nil) # DI foodtruck_dao for easier Unit Testing!
      super(args, local_options, config)
      load_configs!
      @foodtruck_dao = foodtruck_dao || FoodtruckDao.new(@config['token'])

      FileUtils.touch(LOG_FILE) # create log file for debugging
      say WELCOME_MESSAGE, :yellow
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

    desc "current_available_foodtrucks", "foodtrucks that are open now!"
    method_option 'page_size', type: :numeric, :default => 10, aliases: :"-s", :desc => 'number of results to return'
    method_option 'starting_token', type: :numeric, :default => 0, aliases: :"-t", :desc => 'index of the result array where to start the returned list of results'
    method_option 'order_by', type: :string, :enum => OPEN_FOODTRUCK_DISPLAY_KEYS, :default => OPEN_FOODTRUCK_DISPLAY_KEYS[0], aliases: :"-o"
    def current_available_foodtrucks
      starting_token = @options['starting_token']
      
      loop do
        begin
          foodtrucks = @foodtruck_dao.available_foodtrucks_at_this_moment(starting_token, @options['page_size'], @options['order_by'])
        rescue DependencyException => e
          say e.message, :red 
          exit 1
        end

        print_foodtrucks foodtrucks

        break if foodtrucks.size < @options['page_size'] # No more results! Hence exit!
        needmore = ask("Need more Foodtrucks?", :limited_to => ['Y', 'N'], color: :yellow) # Ask user if more results are needed!
        starting_token = starting_token + foodtrucks.size # update the starting_token
        break unless needmore == 'Y'
      end
    end

    private ###############################

    def print_foodtrucks foodtrucks
      rows = foodtrucks.map do |foodtruck|
        row = Array.new
        OPEN_FOODTRUCK_DISPLAY_KEYS.each {|key| row.push(foodtruck[key])}
        row
      end
      table = Terminal::Table.new :title => OPEN_FOODTRUCK_DISPLAY_TITLE, :headings => OPEN_FOODTRUCK_DISPLAY_KEYS, :rows => rows
      puts table
    end

    # Config provided via commandLine > Environments > Config File
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
