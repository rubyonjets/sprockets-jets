module Sprockets::Jets
  module Helper
    extend Memoist

    # Writes over the built in ActionView::Helpers::AssetUrlHelper#compute_asset_path
    # to use the asset pipeline.
    def compute_asset_path(path, options = {})
      if config_assets.use_precompiled
        # Handle precompiled assets
        manifest = Manifest.build # Sprockets::Manifest
        digest_path = manifest.assets[path]
      else
        # Handle on-the-fly assets
        env = Env.build # Sprockets::Environment
        asset = env.find_asset(path) # returns #<Sprockets::Asset>
        env_path = env[path]
        if env_path.nil?
          puts "ERROR: asset not found: path=#{path.inspect} env_path=#{env_path.inspect}".color(:yellow)
          assets_paths = Jets.config.assets.paths.map {|p| "    #{p}" }.join("\n")
          env_paths = env.paths.map {|p| "    #{p}" }.join("\n")
          puts <<~EOL
            Are you sure it exists in one of your asset paths?
            Jets.config.assets.paths:

            #{assets_paths}

            Sprockets env.paths

            #{env_paths}
            EOL
          raise AssetNotFound.new(asset_not_found_message(path))
        end
        digest_path = env_path.digest_path
      end

      if digest_path
        assets_prefix = config_assets.prefix # /assets
        asset_path = [assets_prefix, digest_path].join("/") # /assets/application-1e8f3a4e.css
        # dont call super, otherwise it will add /stylesheets to the path
        # IE: /stylesheets/application.css instead of
        #     /assets/application-381287eca19f4d3ca6a8aa9ed68b8805d918bc26f4597e4f39e30f6259188840.css
      else
        raise AssetNotFound.new(asset_not_found_message(path))
      end
    end

    def asset_not_found_message(path)
      if config_assets.use_precompiled
        <<~EOL
          Precompiled asset not found for: #{path}
          Please run:

            jets assets:precompile

          And restart the server
        EOL
      else
        "Precompiled asset not found for: #{path}"
      end
    end

    # Note: Cannot name config because it conflicts with an ActionView config method
    def config_assets
      Jets.config.assets
    end
  end
end
