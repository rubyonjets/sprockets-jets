module Sprockets::Jets
  class Manifest
    class << self
      extend Memoist

      def build
        env = Env.build # Sprockets::Environment
        Sprockets::Manifest.new(env, "./public/assets")
      end
      memoize :build
    end
  end
end
