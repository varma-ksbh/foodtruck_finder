require 'soda'
require_relative 'constants'

module FoodtruckFinder
  class FoodtruckDao
    include Constants
    def initialize(client = nil, app_token = nil)
      @client = client || SODA::Client.new(
        doman: SOCRATA_DOMAIN,
        app_token: app_token
      )
    end

    def get_foodtruck(id)
      response = @client.get("https://data.sfgov.org/resource/jjew-r69b.json")
      # puts response.body[0]
      # puts "starttime: #{response.body[0]['start24']}, endtime: #{response.body[0]['end24']}"
      # ask "need more records??"
      return "starttime: #{response.body[1]['start24']}, endtime: #{response.body[0]['end24']}"
    end

    def available_foodtrucks_at_this_moment

    end
  end 
end