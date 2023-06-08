$stdout.sync = true unless ENV["SPROCKETS_STDOUT_SYNC"] == "0"

$:.unshift(File.expand_path("../", __FILE__))

require "sprockets/autoloader"
Sprockets::Autoloader.setup

require "memoist"
require "rainbow/ext/string"

module Sprockets
  class Error < StandardError; end
end
