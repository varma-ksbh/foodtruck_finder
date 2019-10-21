require 'soda'

module FoodtruckFinder
  class FoodtruckDao
    def initialize
      @client = SODA::Client.new(
        doman: 'explore.data.gov',
        app_token: ENV['soda_application_token']
      )
    end

    def get_foodtruck(id)
      return "varma"
    end
  end 
end