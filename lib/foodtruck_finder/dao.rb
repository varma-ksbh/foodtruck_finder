require 'soda'
require 'logger'
require_relative 'constants'
require_relative 'exceptions'

module FoodtruckFinder
  class FoodtruckDao
    include Constants 
    @@logger = Logger.new LOG_FILE

    def initialize(app_token = nil, client = nil) # Inject client for easier unit testing!
      @app_token = app_token
      @client = client || SODA::Client.new(
        app_token: @app_token
      )
      @@logger.debug("Initializing SODA Client with app_token #{app_token}")
    end

    def available_foodtrucks_at_this_moment(offset, limit, order_by)
      time = Time.new
      currentTime = "#{time.hour}:#{time.min}"

      query = {
        "$limit" => limit,
        "$offset" => offset,
        "$where" => "dayorder = #{time.wday} AND start24 <= '#{currentTime}' AND end24 >= '#{currentTime}'",
        "$order" => "#{order_by} ASC"
      }
      @@logger.debug("Querying Server with URL: #{SOCRATA_FOODTRUCK_URL} and QUERY: #{query}")
      
      begin
        response = @client.get(SOCRATA_FOODTRUCK_URL, query)
      rescue Exception => e
        @@logger.fatal("Failed to fetch data from Server!")
        @@logger.fatal(e)
        raise DependencyException, "Failed to fetch data from Server! Please check if the Application Token: #{@app_token} is valid" if e.http_code == 403
        raise DependencyException
      end
      
      return response.body
    end
  end 
end