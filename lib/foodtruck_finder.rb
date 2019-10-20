require "foodtruck_finder/version"
require 'thor'

module FoodtruckFinder
  class Error < StandardError; end
  class CLI < Thor
    desc "hello", "Greets you hello!"
  def hello
    puts "Hello world"
  end
  end
end
