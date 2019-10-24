require 'tmpdir'
require 'logger'

module FoodtruckFinder::Constants
  SOCRATA_FOODTRUCK_URL = 'https://data.sfgov.org/resource/jjew-r69b.json'

  CONFIG_FILE = File.join(Dir.home, ".foodtruck-finder.config")
  LOG_FILE = File.join(Dir.tmpdir(), "foodtruck-finder.log")

  WELCOME_MESSAGE = "Feeling Hungry? Foodtruck Finder allows to find open restaurants near you! Enter `foodtruck_finder help`"

  OPEN_FOODTRUCK_DISPLAY_KEYS = ['applicant', 'location']
  OPEN_FOODTRUCK_DISPLAY_TITLE = 'Foodtrucks currently open in San Franciso'
end