module FoodtruckFinder
  class Foodtruck
    attr_reader :name
    def initialize(hash)
      @name = hash
    end
  end
end