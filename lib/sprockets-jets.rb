$:.unshift(File.expand_path("../", __FILE__))

require "sprockets/autoloader"
Sprockets::Autoloader.setup

require "memoist"
require "rainbow/ext/string"
require "sprockets"
require "sprockets/jets/engine"

module Sprockets::Jets
  class Error < StandardError; end
  class AssetNotFound < StandardError; end
end
