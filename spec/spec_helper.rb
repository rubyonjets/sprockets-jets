ENV["SPROCKETS_TEST"] = "1"

# CodeClimate test coverage: https://docs.codeclimate.com/docs/configuring-test-coverage
# require 'simplecov'
# SimpleCov.start

require "pp"
require "byebug"
root = File.expand_path("../", File.dirname(__FILE__))
require "#{root}/lib/sprockets"

module Helper
end

RSpec.configure do |c|
  c.include Helper
end
