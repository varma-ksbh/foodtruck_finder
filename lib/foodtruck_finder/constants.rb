require 'tmpdir'
require 'logger'

module FoodtruckFinder::Constants
  SOCRATA_FOODTRUCK_URL = 'https://data.sfgov.org/resource/jjew-r69b.json'

  CONFIG_FILE = File.join(Dir.home, ".foodtruck-finder.config")
  LOG_FILE = File.join(Dir.tmpdir(), "foodtruck-finder.log")
end