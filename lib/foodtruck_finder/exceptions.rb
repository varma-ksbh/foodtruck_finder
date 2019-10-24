require_relative 'constants'

module FoodtruckFinder
  class DependencyException < StandardError
    include Constants
    def initialize(msg="One of the dependencies failed! Please contact plugin developer with logs: '#{LOG_FILE}'")
      super
    end
  end
end