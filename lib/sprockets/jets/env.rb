module Sprockets::Jets
  class Env
    class << self
      extend Memoist

      def build
        env = Sprockets::Environment.new

        # Set any config.assets values that Sprockets::Environment accepts
        Jets.config.assets.each do |key, value|
          setter = :"#{key}="
          if env.respond_to?(setter)
            env.public_send(setter, value)
          end
        end
        # Set paths
        Jets.config.assets.paths.each do |path|
          env.append_path(path)
        end

        env
      end
      memoize :build
    end
  end
end
